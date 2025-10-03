//
//  IconsTestView.swift
//  GMALite
//
//  Created by Abhishek Babladi on 2025-10-03.
//

import SwiftUI
import DesignAssets

// -----------------------------------------------------------------
// MARK: - Main Test View
// -----------------------------------------------------------------
// Call this view from your ContentView to display the icon library.
// Example:
//
// struct ContentView: View {
//     var body: some View {
//         NavigationStack {
//              IconsTestView()
//         }
//     }
// }
// -----------------------------------------------------------------

public struct IconsTestView: View {
    @State private var selectedCategory: IconCategory = .all
    @State private var searchText = ""
    @State private var colorScheme: ColorScheme = .light
    
    enum IconCategory: String, CaseIterable {
        case all = "All"
        case general = "General"
        case status = "Status"
        case map = "Map"
        case feelGood = "Feel Good"
        case flags = "Flags"
        case deprecated = "Deprecated"
        
        fileprivate var icons: [GeneratedIcons] {
            // Use the main GeneratedIcons enum which has the image property
            let allIcons: [GeneratedIcons] = [
                .deprecated__ic_add_filled_32,
                .deprecated__ic_arrow_right_filled_32,
                .deprecated__ic_chevron_down_filled_32,
                .deprecated__ic_chevron_up_filled_32,
                .deprecated__ic_close_filled_32,
                .deprecated__ic_external_link_filled_32,
                .deprecated__ic_hamburger_filled_32,
                .deprecated__ic_remove_filled_32,
                .deprecated_ic_chevron_left_filled_32,
                .deprecated_ic_chevron_right_filled_32,
                .deprecated_ic_status_alert_12_old,
                .deprecated_ic_status_alert_16_old,
                .deprecated_ic_status_alert_20_old,
                .flagac, .flagad, .flagae, .flagaf, .flagag, .flagai, .flagal, .flagam, .flagao, .flagaq,
                .flagar, .flagas, .flagat, .flagau, .flagaw, .flagax, .flagaz, .flagba, .flagbb, .flagbd,
                .flagbe, .flagbf, .flagbg, .flagbi, .flagbj, .flagbl, .flagbm, .flagbn, .flagbo, .flagbq,
                .flagbr, .flagbs, .flagbt, .flagbv, .flagby, .flagbz, .flagca, .flagcc, .flagcd, .flagcf,
                .flagcg, .flagch, .flagci, .flagck, .flagcl, .flagcm, .flagcn, .flagcr, .flagcu, .flagcw,
                .flagcx, .flagcy, .flagcz, .flagde, .flagdj, .flagdk, .flagdm, .flagdo, .flagdz, .flagec,
                .flagee, .flageh, .flager, .flages, .flaget, .flageu, .flagfj, .flagfk, .flagfm, .flagfo,
                .flagfr, .flagga, .flaggd, .flagge, .flagge_ab, .flagge_os, .flaggf, .flaggg, .flaggi, .flaggl,
                .flaggm, .flaggn, .flaggp, .flaggq, .flaggr, .flaggs, .flaggt, .flaggu, .flaggw, .flaggy,
                .flaghk, .flaghm, .flaghn, .flaghr, .flaght, .flaghu, .flagid, .flagie, .flagil, .flagim,
                .flagin, .flagiq, .flagir, .flagis, .flagit, .flagjm, .flagjo, .flagjp, .flagke, .flagkg,
                .flagkh, .flagkn, .flagkp, .flagkr, .flagky, .flagkz, .flaglb, .flaglc, .flaglk, .flaglr,
                .flagls, .flaglt, .flaglu, .flaglv, .flagly, .flagma, .flagmc, .flagme, .flagmg, .flagmh,
                .flagmk, .flagml, .flagmn, .flagmp, .flagmr, .flagms, .flagmt, .flagmu, .flagmv, .flagmw,
                .flagmx, .flagmz, .flagna, .flagne, .flagnf, .flagng, .flagni, .flagnl, .flagno, .flagnp,
                .flagnr, .flagnu, .flagnz, .flagom, .flagpa, .flagpe, .flagpf, .flagpg, .flagph, .flagpk,
                .flagpl, .flagpm, .flagpn, .flagpr, .flagps, .flagpt, .flagpw, .flagpy, .flagqa, .flagre,
                .flagro, .flagrs, .flagru, .flagrw, .flagsa, .flagsb, .flagsc, .flagsd, .flagse, .flagsg,
                .flagsh, .flagsi, .flagsj, .flagsk, .flagsl, .flagsm, .flagsn, .flagso, .flagsr, .flagss,
                .flagst, .flagsv, .flagsy, .flagsz, .flagta, .flagtc, .flagtd, .flagtf, .flagtg, .flagth,
                .flagtj, .flagtk, .flagtl, .flagtm, .flagtn, .flagto, .flagtr, .flagtt, .flagtv, .flagtw,
                .flagtz, .flagua, .flagug, .flagus, .flaguy, .flaguz, .flagva, .flagvc, .flagve, .flagvg,
                .flagvi, .flagvn, .flagvu, .flagwf, .flagws, .flagye, .flagyt, .flagza, .flagzm, .flagzw,
                .ic_accessibility_default_32, .ic_accessibility_filled_32, .ic_address_default_32, .ic_address_filled_32,
                .ic_alert_default_32, .ic_alert_filled_32, .ic_bag_default_32, .ic_bag_filled_32, .ic_bar_code_default_32,
                .ic_bar_code_filled_32, .ic_blocker_default_32, .ic_blocker_filled_32, .ic_calendar_default_32, .ic_calendar_filled_32,
                .ic_charging_default_32, .ic_charging_filled_32, .ic_check_default_32, .ic_check_filled_32, .ic_chevron_down_default_32,
                .ic_chevron_left_default_32, .ic_chevron_right_default_32, .ic_chevron_up_default_32, .ic_close_default_32,
                .ic_cold_kiosk_default_32, .ic_cold_kiosk_filled_32, .ic_counter_default_32, .ic_counter_filled_32,
                .ic_curbside_default_32, .ic_curbside_filled_32, .ic_delivery_instructions_alt2_default_32, .ic_delivery_instructions_alt2_filled_32,
                .ic_delivery_instructions_default_32, .ic_delivery_instructions_filled_32, .ic_drive_thru_default_32, .ic_drive_thru_filled_32,
                .ic_eat_in_default_32, .ic_eat_in_filled_32, .ic_edit_default_32, .ic_edit_filled_32, .ic_external_link_default_32,
                .ic_filter_active_32, .ic_find_me_android_default_32, .ic_find_me_android_filled_32, .ic_find_me_android_no_permission_32,
                .ic_find_me_ios_default_32, .ic_find_me_ios_filled_32, .ic_find_me_ios_no_permission_32, .ic_flash_default_32,
                .ic_flash_filled_32, .ic_full_screen_default_32, .ic_hamburger_default_32, .ic_hide_default_32,
                .ic_hide_filled_32, .ic_ios_back, .ic_keypad_default_32, .ic_keypad_filled_32, .ic_kiosk_default_32,
                .ic_kiosk_filled_32, .ic_language_default_32, .ic_language_filled_32, .ic_leave_at_door_default_32,
                .ic_leave_at_door_filled_32, .ic_light_bulb_default_32, .ic_light_bulb_filled_32, .ic_light_off_bulb_default_32,
                .ic_light_off_bulb_filled_32, .ic_link_arrow, .ic_link_directions_16, .ic_link_external_link_16, .ic_list_default_32,
                .ic_list_filled_32, .ic_list_search_default_32, .ic_log_out_default_32, .ic_log_out_filled_32,
                .ic_mccafe_default_32, .ic_mccafe_filled_32, .ic_meal_default_32, .ic_meal_filled_32, .ic_nav_list_default_32,
                .ic_order_delivery_32, .ic_order_delivery_disabled_32, .ic_order_location_32, .ic_order_location_green_32,
                .ic_pause_default, .ic_pause_filled, .ic_phone_alt2_default_32, .ic_play_default, .ic_play_filled,
                .ic_playground_default_32, .ic_playground_filled_32, .ic_recents_default_32, .ic_refresh_default_32,
                .ic_refresh_filled_32, .ic_remove_default_32, .ic_search_default_32, .ic_search_filled_32,
                .ic_status_alert_12, .ic_status_alert_16, .ic_status_alert_20, .ic_status_blocker_12, .ic_status_blocker_16,
                .ic_status_blocker_20, .ic_status_check, .ic_status_false_20v2, .ic_status_info_12, .ic_status_info_16,
                .ic_status_info_20, .ic_status_selected_12, .ic_status_selected_16, .ic_status_selected_20,
                .ic_status_success_12, .ic_status_success_16, .ic_status_success_20, .ic_trash_default_32,
                .ic_walk_thru_default_32, .ic_wi_fi_default_32, .ic_wi_fi_filled_32, .ic_location_no_mobile_order_32,
                .ic_map_default_32, .ic_map_filled_32, .map_pin_single_default, .map_pin_single_default_green,
                .map_pin_single_disabled, .map_pin_single_disabled_green, .map_pin_single_no_mobile_order_default,
                .map_pin_single_no_mobile_order_disabled, .stateactive_colorred, .statedefault_colorred,
                .statedefault_coloryellow, .statedefault_mobile_orderfalse_themedefault, .statedefault_mobile_ordertrue_themedefault,
                .statedefault_mobile_ordertrue_themeeurope_green, .statedisabled_colorgrey, .statedisabled_mobile_orderfalse_themedefault,
                .statedisabled_mobile_ordertrue_themedefault, .statedisabled_mobile_ordertrue_themeeurope_green, .statestate5_coloryellow
            ]
            
            switch self {
            case .all:
                return allIcons
            case .general:
                return allIcons.filter { icon in
                    let name = String(describing: icon).lowercased()
                    return name.hasPrefix("ic_") && 
                           !name.contains("status") && 
                           !name.contains("map") && 
                           !name.contains("flag") &&
                           !name.contains("deprecated")
                }
            case .status:
                return allIcons.filter { String(describing: $0).lowercased().contains("status") }
            case .map:
                return allIcons.filter { icon in
                    let name = String(describing: icon).lowercased()
                    return name.contains("map") || name.contains("location") || name.contains("pin")
                }
            case .feelGood:
                return allIcons.filter { icon in
                    let name = String(describing: icon).lowercased()
                    return name.contains("light") || name.contains("bulb") || name.contains("playground")
                }
            case .flags:
                return allIcons.filter { String(describing: $0).lowercased().hasPrefix("flag") }
            case .deprecated:
                return allIcons.filter { String(describing: $0).lowercased().contains("deprecated") }
            }
        }
    }
    
    fileprivate var filteredIcons: [GeneratedIcons] {
        let categoryIcons = selectedCategory.icons
        if searchText.isEmpty {
            return categoryIcons
        } else {
            return categoryIcons.filter { String(describing: $0).localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SectionContainer(title: "Design Assets Icons") {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Icons from Figma via DesignAssets package.")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                        
                        // Dark/Light mode toggle
                        HStack {
                            Button(action: {
                                colorScheme = colorScheme == .light ? .dark : .light
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: colorScheme == .light ? "moon.fill" : "sun.max.fill")
                                    Text(colorScheme == .light ? "Dark Mode" : "Light Mode")
                                }
                                .font(.system(size: 12, weight: .medium))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.secondary.opacity(0.1))
                                )
                            }
                            .buttonStyle(.plain)
                            
                            Spacer()
                        }
                        .preferredColorScheme(colorScheme)
                        
                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            TextField("Search icons...", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.secondary.opacity(0.1)))
                        
                        // Category picker
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(IconCategory.allCases, id: \.rawValue) { category in
                                    Button(action: { selectedCategory = category }) {
                                        Text(category.rawValue)
                                            .font(.system(size: 14, weight: .medium))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(selectedCategory == category ? Color.accentColor : Color.secondary.opacity(0.1))
                                            )
                                            .foregroundStyle(selectedCategory == category ? .white : .primary)
                                    }
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                        
                        // Icons count
                        Text("\(filteredIcons.count) icons")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                        
                        // Icons grid
                        FlowWrap {
                            ForEach(Array(filteredIcons.enumerated()), id: \.offset) { index, iconName in
                                EnhancedIconCard(iconName: iconName, colorScheme: colorScheme)
                            }
                        }
                    }
                }
            }
            .padding(16)
            .padding(.bottom, 40)
        }
        .navigationTitle("Icons")
    }
}

// -----------------------------------------------------------------
// MARK: - Private Helper Views
// -----------------------------------------------------------------

private struct EnhancedIconCard: View {
    let iconName: GeneratedIcons
    let colorScheme: ColorScheme
    
    private var category: String {
        let name = String(describing: iconName).lowercased()
        if name.contains("status") {
            return "Status"
        } else if name.contains("map") || name.contains("location") || name.contains("pin") {
            return "Map"
        } else if name.contains("flag") {
            return "Flag"
        } else if name.contains("deprecated") {
            return "Deprecated"
        } else if name.contains("light") || name.contains("bulb") || name.contains("playground") {
            return "Feel Good"
        } else {
            return "General"
        }
    }
    
    private var platformColor: Color {
        let name = String(describing: iconName).lowercased()
        if name.contains("status") {
            return .green
        } else if name.contains("map") || name.contains("location") || name.contains("pin") {
            return .blue
        } else if name.contains("flag") {
            return .orange
        } else if name.contains("deprecated") {
            return .red
        } else if name.contains("light") || name.contains("bulb") || name.contains("playground") {
            return .yellow
        } else {
            return .primary
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon display with platform color background
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(platformColor.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                // Use actual GeneratedIcons icon loading
                iconName.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
            }
            
            // Icon name
            Text(String(describing: iconName).replacingOccurrences(of: "_", with: " ").capitalized)
                .font(.system(size: 12, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Category badge
            Text(category)
                .font(.system(size: 10, weight: .medium))
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    Capsule()
                        .fill(platformColor.opacity(0.2))
                )
                .foregroundStyle(platformColor)
            
            // Usage example
            Text("GeneratedIcons.\(String(describing: iconName))")
                .font(.system(size: 9))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Icon size info
            VStack(spacing: 4) {
                Text("Size:")
                    .font(.system(size: 8))
                    .foregroundStyle(.secondary)
                
                Text("32x32")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 140)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.secondary.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(platformColor.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

private struct SectionContainer<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
            content
        }
    }
}

private struct FlowWrap<Content: View>: View {
    @ViewBuilder let content: Content

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 140), spacing: 12, alignment: .top)]
    }

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
            content
        }
    }
}

// -----------------------------------------------------------------
// MARK: - SwiftUI Preview
// -----------------------------------------------------------------

#Preview {
    NavigationStack {
        IconsTestView()
    }
}
