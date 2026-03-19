//
//  SettingsView.swift
//  sober-sense
//

import SwiftUI
import Combine

// MARK: - BAC Level Model

struct BACLevel: Identifiable {
    let id = UUID()
    let label: String
    let range: String
    let description: String
    let color: Color
    let threshold: Double
}

let bacLevels: [BACLevel] = [
    BACLevel(label: "Impaired",          range: "0.05 – 0.08", description: "Impaired judgment, decreased coordination",    color: Color(hex: "#FFC107"), threshold: 0.05),
    BACLevel(label: "Legal Limit",       range: "0.08 – 0.15", description: "Significant motor impairment, slurred speech", color: Color(hex: "#FF9800"), threshold: 0.08),
    BACLevel(label: "Severe Impairment", range: "0.16 – 0.30", description: "Nausea, danger of falling, blackout risk",     color: Color(hex: "#F44336"), threshold: 0.16),
]

// MARK: - App Model

struct PhoneApp: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let icon: String
    var assignedLevelIndex: Int?
}

// MARK: - Settings View Model

class SettingsViewModel: ObservableObject {
    @Published var apps: [PhoneApp] = [
        PhoneApp(name: "Instagram",   icon: "camera",            assignedLevelIndex: nil),
        PhoneApp(name: "TikTok",      icon: "play.rectangle",    assignedLevelIndex: nil),
        PhoneApp(name: "Twitter / X", icon: "bird",              assignedLevelIndex: nil),
        PhoneApp(name: "Snapchat",    icon: "camera.aperture",   assignedLevelIndex: nil),
        PhoneApp(name: "Uber",        icon: "car",               assignedLevelIndex: nil),
        PhoneApp(name: "Lyft",        icon: "car.2",             assignedLevelIndex: nil),
        PhoneApp(name: "DoorDash",    icon: "bag",               assignedLevelIndex: nil),
        PhoneApp(name: "Messages",    icon: "message",           assignedLevelIndex: nil),
        PhoneApp(name: "Venmo",       icon: "dollarsign.circle", assignedLevelIndex: nil),
        PhoneApp(name: "Tinder",      icon: "flame",             assignedLevelIndex: nil),
        PhoneApp(name: "Amazon",      icon: "cart",              assignedLevelIndex: nil),
        PhoneApp(name: "Email",       icon: "envelope",          assignedLevelIndex: nil),
    ]

    @Published var draggingApp: PhoneApp? = nil

    func assign(app: PhoneApp, to levelIndex: Int?) {
        if let i = apps.firstIndex(where: { $0.id == app.id }) {
            apps[i].assignedLevelIndex = levelIndex
        }
    }

    func appsForLevel(_ index: Int) -> [PhoneApp] {
        apps.filter { $0.assignedLevelIndex == index }
    }

    func unassignedApps() -> [PhoneApp] {
        apps.filter { $0.assignedLevelIndex == nil }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @StateObject private var vm = SettingsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Drag apps to the BAC level where you'd like them disabled.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 24)

                    ForEach(Array(bacLevels.enumerated()), id: \.element.id) { index, level in
                        BACLevelBucket(level: level, levelIndex: index, vm: vm)
                            .padding(.bottom, 16)
                    }

                    UnassignedPool(vm: vm)
                        .padding(.bottom, 40)
                }
            }
            .navigationTitle("App Controls")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - BAC Level Bucket

struct BACLevelBucket: View {
    let level: BACLevel
    let levelIndex: Int
    @ObservedObject var vm: SettingsViewModel
    @State private var isTargeted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(level.color)
                    .frame(width: 6, height: 40)
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 8) {
                        Text(level.label)
                            .font(.system(size: 15, weight: .semibold))
                        Text(level.range)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(level.color.opacity(0.15)))
                    }
                    Text(level.description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)

            let assignedApps = vm.appsForLevel(levelIndex)

            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isTargeted ? level.color.opacity(0.12) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                isTargeted ? level.color : level.color.opacity(0.3),
                                style: StrokeStyle(lineWidth: isTargeted ? 2 : 1, dash: isTargeted ? [] : [6, 4])
                            )
                    )
                    .frame(minHeight: 70)

                if assignedApps.isEmpty {
                    Text("Drop apps here")
                        .font(.system(size: 13))
                        .foregroundColor(level.color.opacity(0.5))
                        .padding(.vertical, 20)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(assignedApps) { app in
                                AppChip(app: app, accentColor: level.color, vm: vm)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                    }
                }
            }
            .padding(.horizontal, 20)
            .dropDestination(for: String.self) { items, _ in
                guard let appID = items.first,
                      let app = vm.apps.first(where: { $0.id.uuidString == appID })
                else { return false }
                vm.assign(app: app, to: levelIndex)
                return true
            } isTargeted: { isTargeted = $0 }
        }
    }
}

// MARK: - Unassigned Pool

struct UnassignedPool: View {
    @ObservedObject var vm: SettingsViewModel
    @State private var isTargeted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "square.grid.2x2")
                    .foregroundColor(.buttonBorder)
                Text("Available Apps")
                    .font(.system(size: 15, weight: .semibold))
            }
            .padding(.horizontal, 20)

            Text("Drag an app onto a BAC level above to restrict it.")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)

            let unassigned = vm.unassignedApps()

            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isTargeted ? Color.buttonBorder.opacity(0.08) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.buttonBorder.opacity(isTargeted ? 0.6 : 0.2), lineWidth: 1)
                    )
                    .frame(minHeight: 80)

                if unassigned.isEmpty {
                    Text("All apps assigned ✓")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .padding(.vertical, 24)
                } else {
                    FlowLayout(spacing: 10) {
                        ForEach(unassigned) { app in
                            AppChip(app: app, accentColor: .buttonBorder, vm: vm)
                        }
                    }
                    .padding(14)
                }
            }
            .padding(.horizontal, 20)
            .dropDestination(for: String.self) { items, _ in
                guard let appID = items.first,
                      let app = vm.apps.first(where: { $0.id.uuidString == appID })
                else { return false }
                vm.assign(app: app, to: nil)
                return true
            } isTargeted: { isTargeted = $0 }
        }
    }
}

// MARK: - App Chip

struct AppChip: View {
    let app: PhoneApp
    let accentColor: Color
    @ObservedObject var vm: SettingsViewModel

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: app.icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(accentColor)
            Text(app.name)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.primary)
            Button {
                vm.assign(app: app, to: nil)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
            .opacity(app.assignedLevelIndex != nil ? 1 : 0)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(accentColor.opacity(0.12))
                .overlay(Capsule().stroke(accentColor.opacity(0.4), lineWidth: 1))
        )
        .draggable(app.id.uuidString)
        .onTapGesture {
            // TODO: navigate to per-app detail settings
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 { x = 0; y += rowHeight + spacing; rowHeight = 0 }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0
        for view in subviews {
            let size = view.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX { x = bounds.minX; y += rowHeight + spacing; rowHeight = 0 }
            view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - Color hex helper

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
