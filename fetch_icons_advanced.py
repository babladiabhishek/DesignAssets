#!/usr/bin/env python3

import requests
import json
import os
import time
import logging
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor
from typing import Dict, List, Optional
import sys

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler()]
)
logger = logging.getLogger(__name__)

# Configuration
class Config:
    FIGMA_FILE_ID = os.getenv('FIGMA_FILE_ID', '')
    FIGMA_PERSONAL_TOKEN = os.getenv('FIGMA_PERSONAL_TOKEN', '')
    OUTPUT_DIR = 'Sources/DesignAssets/Resources'
    TEMP_DIR = 'temp_assets'
    BATCH_SIZE = 10
    RETRY_ATTEMPTS = 3
    RETRY_DELAY = 2

def setup_environment() -> bool:
    """Set up environment and validate required configuration."""
    if not Config.FIGMA_FILE_ID or not Config.FIGMA_PERSONAL_TOKEN:
        logger.error("Missing FIGMA_FILE_ID or FIGMA_PERSONAL_TOKEN environment variables.")
        return False
    os.makedirs(Config.TEMP_DIR, exist_ok=True)
    os.makedirs(Config.OUTPUT_DIR, exist_ok=True)
    return True

def fetch_with_retry(url: str, headers: dict, params: dict = None, retries: int = Config.RETRY_ATTEMPTS) -> requests.Response:
    """Fetch with exponential backoff retries."""
    for attempt in range(retries):
        try:
            response = requests.get(url, headers=headers, params=params, timeout=10)
            response.raise_for_status()
            return response
        except requests.RequestException as e:
            if attempt == retries - 1:
                logger.error(f"Failed after {retries} attempts: {e}")
                raise
            wait_time = Config.RETRY_DELAY * (2 ** attempt)
            logger.warning(f"Attempt {attempt + 1} failed: {e}. Retrying in {wait_time}s...")
            time.sleep(wait_time)
    raise Exception("Unexpected retry exhaustion")

def fetch_figma_file(file_id: str, token: str) -> dict:
    """Fetch Figma file metadata with retry logic."""
    url = f"https://api.figma.com/v1/files/{file_id}"
    headers = {"X-Figma-Token": token}
    response = fetch_with_retry(url, headers)
    return response.json()

def fetch_image_urls(file_id: str, node_ids: List[str], token: str) -> dict:
    """Fetch image URLs for multiple nodes with retry logic."""
    url = f"https://api.figma.com/v1/images/{file_id}"
    params = {"ids": ",".join(node_ids), "format": "svg", "scale": "1"}
    headers = {"X-Figma-Token": token}
    response = fetch_with_retry(url, headers, params)
    return response.json()

def download_svg(url: str, filepath: str) -> bool:
    """Download SVG file with retry logic."""
    try:
        response = fetch_with_retry(url, {})
        os.makedirs(os.path.dirname(filepath), exist_ok=True)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(response.text)
        return True
    except Exception as e:
        logger.error(f"Failed to download SVG to {filepath}: {e}")
        return False

def clean_icon_name(name: str) -> str:
    """Clean up icon name for file system and Swift enum."""
    clean_name = name.replace('/', '_').replace('\\', '_').replace(' ', '_')
    clean_name = ''.join(c for c in clean_name if c.isalnum() or c in '_-')
    return clean_name

def fuzzy_match_ratio(str1: str, str2: str) -> int:
    """Simple fuzzy matching without external dependencies."""
    str1, str2 = str1.lower(), str2.lower()
    if str1 == str2:
        return 100
    if str1 in str2 or str2 in str1:
        return 80
    # Simple character overlap calculation
    common_chars = sum(1 for c in str1 if c in str2)
    return int((common_chars / max(len(str1), len(str2))) * 100)

def determine_category_with_accuracy(full_name: str, layer_name: str, component_data: dict) -> str:
    """Determine category using an advanced scoring algorithm."""
    name_lower = full_name.lower()
    layer_lower = layer_name.lower()

    # Define categories and their feature weights
    categories = {
        "Flags": {"prefixes": ["flag_"], "keywords": ["flag"], "layer": ["flag"], "weight": 0.9},
        "Logos": {"prefixes": [], "keywords": ["logo"], "layer": ["logo"], "weight": 0.85},
        "Private": {"layer": [".private"], "weight": 0.95},
        "Annotations": {"layer": ["annotation"], "weight": 0.9},
        "Icons": {"prefixes": ["ic_"], "keywords": [], "weight": 0.7},
        "Map": {"prefixes": ["map_"], "weight": 0.8},
        "Status": {"prefixes": ["status_"], "weight": 0.75},
        "Navigation": {"prefixes": ["navigation_"], "weight": 0.75},
        "Illustrations": {"prefixes": ["il_"], "weight": 0.8},
        "Images": {"prefixes": ["im_"], "weight": 0.8},
        "Other": {"weight": 0.1}  # Default fallback
    }

    # Feature extraction
    all_prefixes = []
    all_keywords = []
    all_layers = []
    
    for category, rules in categories.items():
        all_prefixes.extend(rules.get("prefixes", []))
        all_keywords.extend(rules.get("keywords", []))
        all_layers.extend(rules.get("layer", []))
    
    features = {
        "prefix": next((p for p in all_prefixes if name_lower.startswith(p)), None),
        "keyword": next((k for k in all_keywords if k in name_lower), None),
        "layer_match": layer_lower in all_layers,
        "depth": full_name.count('/')  # Simple depth indicator
    }

    # Scoring
    scores = {}
    for category, rules in categories.items():
        score = 0.0
        if features["prefix"] and features["prefix"] in rules.get("prefixes", []):
            score += 0.4
        if features["keyword"] and features["keyword"] in rules.get("keywords", []):
            score += 0.2
        if features["layer_match"] and layer_lower in rules.get("layer", []):
            score += 0.3
        if layer_lower == "root" and category in ["Icons", "Map", "Status", "Navigation", "Illustrations", "Images"]:
            score += 0.1 * (1.0 - features["depth"] / 5.0)  # Penalize deeper nodes
        score += rules["weight"] * 0.1  # Base weight
        scores[category] = score

    # Fuzzy matching for edge cases
    if max(scores.values()) < 0.5:
        for cat, rules in categories.items():
            for keyword in rules.get("keywords", []) + rules.get("prefixes", []):
                if fuzzy_match_ratio(name_lower, keyword) > 80:
                    scores[cat] += 0.3
                    break

    # Select category with highest score
    best_category = max(scores.items(), key=lambda x: x[1])[0]
    if scores[best_category] < 0.6:
        logger.warning(f"Low confidence categorization for {full_name}: {best_category} (score: {scores[best_category]:.2f})")
    return best_category

def create_imageset(icon_name: str, svg_path: str, category: str) -> bool:
    """Create .imageset directory with Contents.json and SVG."""
    xcassets_dir = f"{Config.OUTPUT_DIR}/{category}.xcassets"
    imageset_dir = f"{xcassets_dir}/{icon_name}.imageset"
    
    try:
        os.makedirs(imageset_dir, exist_ok=True)
        
        contents = {
            "images": [{"filename": f"{icon_name}.svg", "idiom": "universal", "scale": "1x"}],
            "info": {"author": "xcode", "version": 1},
            "properties": {"preserves-vector-representation": True}
        }
        with open(f"{imageset_dir}/Contents.json", 'w') as f:
            json.dump(contents, f, indent=2)
        
        svg_filename = f"{imageset_dir}/{icon_name}.svg"
        with open(svg_path, 'r') as src, open(svg_filename, 'w') as dst:
            dst.write(src.read())
        return True
    except Exception as e:
        logger.error(f"Failed to create imageset for {icon_name}: {e}")
        return False

def create_xcassets_contents(category: str) -> bool:
    """Create Contents.json for the xcassets folder."""
    xcassets_dir = f"{Config.OUTPUT_DIR}/{category}.xcassets"
    try:
        contents = {"info": {"author": "xcode", "version": 1}}
        with open(f"{xcassets_dir}/Contents.json", 'w') as f:
            json.dump(contents, f, indent=2)
        return True
    except Exception as e:
        logger.error(f"Failed to create Contents.json for {category}: {e}")
        return False

def process_icon_batch(file_id: str, token: str, batch: List[dict], category: str, force_download: bool = False) -> tuple:
    """Process a batch of icons concurrently."""
    node_ids = [icon['node_id'] for icon in batch]
    image_data = fetch_image_urls(file_id, node_ids, token)
    images = image_data.get('images', {})
    downloaded = 0
    failed = []

    def process_single_icon(icon: dict) -> tuple:
        node_id = icon['node_id']
        clean_name = icon['clean_name']
        original_name = icon['original_name']
        layer = icon['layer']
        if node_id in images and images[node_id]:
            svg_path = os.path.join(Config.TEMP_DIR, f"{clean_name}.svg")
            if download_svg(images[node_id], svg_path):
                if create_imageset(clean_name, svg_path, category):
                    os.remove(svg_path)
                    logger.info(f"✅ {clean_name} (from {layer})")
                    return True, None
                else:
                    failed.append(f"Imageset creation failed for {original_name}")
            else:
                failed.append(f"Download failed for {original_name}")
        else:
            failed.append(f"No image URL for {original_name} (from {layer})")
        return False, None

    with ThreadPoolExecutor(max_workers=4) as executor:
        results = list(executor.map(process_single_icon, batch))
    downloaded = sum(1 for success, _ in results if success)
    return downloaded, failed

def main() -> int:
    """Main execution function with pipeline compatibility."""
    if not setup_environment():
        return 1

    file_id = Config.FIGMA_FILE_ID
    token = Config.FIGMA_PERSONAL_TOKEN
    
    # Check for force download flag (useful in CI/CD)
    force_download = os.getenv('FORCE_DOWNLOAD', 'false').lower() == 'true'
    if force_download:
        logger.info("🔄 Force download enabled - will re-download all icons")

    logger.info("🔍 Fetching production Figma file with advanced categorization...")
    file_data = fetch_figma_file(file_id, token)
    logger.info(f"📋 File: {file_data.get('name', 'Unknown')}")
    logger.info(f"📅 Last Modified: {file_data.get('lastModified', 'Unknown')}")

    components = file_data.get('components', {})
    logger.info(f"📦 Total Components: {len(components)}")

    categorized_icons = defaultdict(list)
    total_icons = 0

    logger.info("\n🔍 Analyzing components by advanced categorization...")
    for node_id, component in components.items():
        full_name = component.get('name', '')
        if '/' in full_name:
            layer_name = full_name.split('/')[0].strip()
            icon_name = full_name.split('/')[-1].strip()
        else:
            layer_name = "Root"
            icon_name = full_name

        if (icon_name and icon_name != 'Placeholder' and
            any(icon_name.lower().startswith(prefix) for prefix in ['ic_', 'map_', 'status_', 'navigation_', 'il_', 'im_', 'flag_']) or
            'logo' in icon_name.lower() or layer_name.lower() in ['flag', 'logo']):
            category = determine_category_with_accuracy(full_name, layer_name, component)
            clean_name = clean_icon_name(icon_name)
            categorized_icons[category].append({
                'node_id': node_id,
                'original_name': icon_name,
                'clean_name': clean_name,
                'layer': layer_name,
                'full_name': full_name
            })
            total_icons += 1

    logger.info(f"🎯 Found {total_icons} icons across {len(categorized_icons)} categories")
    for category, icons in categorized_icons.items():
        layers = set(icon['layer'] for icon in icons)
        logger.info(f"  📂 {category}: {len(icons)} icons")
        logger.info(f"      └─ From Figma layers: {', '.join(sorted(layers))}")

    logger.info(f"\n📁 Creating asset catalogs...")
    for category in categorized_icons.keys():
        if create_xcassets_contents(category):
            logger.info(f"  ✅ Created {category}.xcassets")

    total_downloaded = 0
    failed_downloads = []

    for category, icons in categorized_icons.items():
        logger.info(f"\n🎨 Processing {category} category ({len(icons)} icons)...")
        for i in range(0, len(icons), Config.BATCH_SIZE):
            batch = icons[i:i + Config.BATCH_SIZE]
            batch_num = i // Config.BATCH_SIZE + 1
            total_batches = (len(icons) + Config.BATCH_SIZE - 1) // Config.BATCH_SIZE
            logger.info(f"  🔄 Processing batch {batch_num}/{total_batches}")
            downloaded, batch_failed = process_icon_batch(file_id, token, batch, category, force_download)
            total_downloaded += downloaded
            failed_downloads.extend(batch_failed)
            if i + Config.BATCH_SIZE < len(icons):
                time.sleep(0.5)

    logger.info(f"\n🎉 SUMMARY:")
    logger.info(f"  ✅ Successfully downloaded: {total_downloaded} icons")
    logger.info(f"  ❌ Failed downloads: {len(failed_downloads)}")

    if failed_downloads:
        logger.warning(f"\n❌ Failed Downloads (first 10):")
        for error in failed_downloads[:10]:
            logger.warning(f"  - {error}")
        if len(failed_downloads) > 10:
            logger.warning(f"  ... and {len(failed_downloads) - 10} more errors")

    logger.info(f"\n🔧 Generating Swift code...")
    generate_swift_code(categorized_icons)
    logger.info("  ✅ Generated Swift code")

    return 0 if not failed_downloads else 1

def generate_swift_code(categorized_icons: Dict[str, List[dict]]) -> None:
    """Generate comprehensive Swift code."""
    swift_code = '''import Foundation
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(UIKit)
import UIKit
#endif

public enum GeneratedIcons {
    public static let bundle = Bundle.module
    
    public static var allIcons: [String] {
        return [
'''
    all_icons = sorted({icon['clean_name'] for icons in categorized_icons.values() for icon in icons})
    for icon_name in all_icons:
        swift_code += f'            "{icon_name}",\n'
    swift_code += '''        ]
    }
    
    public static var categories: [String] {
        return [
'''
    for category in sorted(categorized_icons.keys()):
        swift_code += f'            "{category}",\n'
    swift_code += '''        ]
    }
    
    public static var totalIconCount: Int {
        return allIcons.count
    }
}
'''
    with open('Sources/DesignAssets/GeneratedIcons.swift', 'w') as f:
        f.write(swift_code)

if __name__ == "__main__":
    sys.exit(main())
