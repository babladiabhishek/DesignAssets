import Foundation

print("🚀 Starting simple test...")

// Test basic async functionality
Task {
    print("📦 Inside Task block")
    
    // Test a simple async operation
    try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
    
    print("✅ Task completed successfully")
}

print("🏁 Script finished")
