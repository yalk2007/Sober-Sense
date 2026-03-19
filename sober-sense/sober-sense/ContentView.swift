//
//  ContentView.swift
//  sober-sense
//

import SwiftUI

enum AppTab {
    case data, home, settings, profile
}

struct ContentView: View {
    @StateObject private var profileManager = ProfileManager()
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("", systemImage: Constants.dataIconString, value: AppTab.data) {
                NavigationView { DataView() }
            }
            Tab("", systemImage: Constants.homeIconString, value: AppTab.home) {
                NavigationView {
                    HomeView(profileManager: profileManager)
                        .navigationTitle("Sober Sense")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            Tab("", systemImage: "gearshape", value: AppTab.settings) {
                SettingsView()
            }
            Tab("", systemImage: Constants.profileIconString, value: AppTab.profile) {
                NavigationView {
                    ProfileView(profileManager: profileManager)
                }
            }
        }
        .tint(.buttonBorder)
    }
}

#Preview {
    ContentView()
}
