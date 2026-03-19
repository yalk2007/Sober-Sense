//
//  HouseView.swift
//  sober-sense
//

import SwiftUI

// MARK: - Shared Data Model

struct BACEntry: Identifiable {
    let id = UUID()
    let date: Date
    let peakBAC: Double
}

let sampleHistory: [BACEntry] = [
    BACEntry(date: Date().addingTimeInterval(-86400),     peakBAC: 0.08),
    BACEntry(date: Date().addingTimeInterval(-86400 * 3), peakBAC: 0.05),
    BACEntry(date: Date().addingTimeInterval(-86400 * 7), peakBAC: 0.12),
]

// MARK: - Shared History Card

struct HistoryCard: View {
    let entry: BACEntry

    var dateString: String {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f.string(from: entry.date)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(dateString)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                Text(String(format: "Peak BAC: %.2f", entry.peakBAC))
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(String(format: "%.2f", entry.peakBAC))
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.buttonBorder)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.buttonBorder, lineWidth: 2)
                )
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.leading, 8)
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color(.systemGray6)))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Color.buttonBorder.opacity(0.4), lineWidth: 1))
        .padding(.horizontal, 20)
    }
}

// MARK: - Home Screen

struct HomeView: View {
    @ObservedObject var profileManager: ProfileManager

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Your BAC is:")
                        .textUniversal()
                    Text("0.00")
                        .numberText()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 50)
                .padding(.bottom, 60)

                VStack(alignment: .leading, spacing: 16) {
                    Text("History")
                        .textUniversal()
                        .padding(.horizontal, 20)
                    ForEach(sampleHistory) { entry in
                        NavigationLink(destination: DayDetailView(entry: entry)) {
                            HistoryCard(entry: entry)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("Sober Sense")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Data View

struct DataView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("History")
                    .textUniversal()
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                ForEach(sampleHistory) { entry in
                    NavigationLink(destination: DayDetailView(entry: entry)) {
                        HistoryCard(entry: entry)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Data")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Day Detail View

struct DayDetailView: View {
    let entry: BACEntry

    var dateString: String {
        let f = DateFormatter()
        f.dateStyle = .long
        return f.string(from: entry.date)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text(dateString)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                    Text(String(format: "%.2f", entry.peakBAC))
                        .font(.system(size: 72, weight: .bold))
                        .foregroundColor(.buttonBorder)
                    Text("Peak BAC")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color(.systemGray6))
                        .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous).stroke(Color.buttonBorder.opacity(0.4), lineWidth: 1))
                )
                .padding(.horizontal, 20)

                SectionCard(title: "BAC Over Time") {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray5)).frame(height: 160)
                        Text("Graph coming soon").foregroundColor(.secondary).font(.system(size: 14))
                    }
                }

                SectionCard(title: "Where You Went") {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray5)).frame(height: 180)
                        VStack(spacing: 8) {
                            Image(systemName: "map").font(.system(size: 32)).foregroundColor(.buttonBorder.opacity(0.6))
                            Text("Location tracking coming soon").foregroundColor(.secondary).font(.system(size: 14))
                        }
                    }
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
        }
        .navigationTitle(dateString)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.system(size: 17, weight: .semibold)).padding(.horizontal, 20)
            content.padding(.horizontal, 20)
        }
    }
}

// MARK: - Profile

struct ProfileView: View {
    @ObservedObject var profileManager: ProfileManager
    @State private var isEditingProfile = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 15) {
                    ZStack {
                        Circle().fill(Color.buttonBorder.opacity(0.2)).frame(width: 100, height: 100)
                        Image(systemName: "person.fill").resizable().scaledToFit().frame(width: 50, height: 50).foregroundColor(.buttonBorder)
                    }
                    Text(profileManager.currentProfile.name).font(.title2).fontWeight(.semibold)
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 15) {
                    Text("Personal Information").font(.headline).padding(.horizontal)
                    VStack(spacing: 0) {
                        ProfileInfoRow(label: "Name",   value: profileManager.currentProfile.name)
                        Divider().padding(.leading)
                        ProfileInfoRow(label: "Weight", value: "\(Int(profileManager.currentProfile.weight)) lbs")
                        Divider().padding(.leading)
                        ProfileInfoRow(label: "Gender", value: profileManager.currentProfile.gender.rawValue)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                Button(action: { isEditingProfile = true }) {
                    Text("Edit Profile").frame(maxWidth: .infinity).padding()
                        .background(Color.buttonBorder).foregroundColor(.white).cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $isEditingProfile) {
            EditProfileView(profileManager: profileManager, isPresented: $isEditingProfile)
        }
    }
}

struct ProfileInfoRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label).foregroundColor(.gray)
            Spacer()
            Text(value).fontWeight(.medium)
        }
        .padding()
    }
}

struct EditProfileView: View {
    @ObservedObject var profileManager: ProfileManager
    @Binding var isPresented: Bool
    @State private var editName: String = ""
    @State private var editWeight: String = ""
    @State private var editGender: UserProfile.Gender = .male

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Details")) {
                    TextField("Name", text: $editName)
                    TextField("Weight (lbs)", text: $editWeight).keyboardType(.numberPad)
                    Picker("Gender", selection: $editGender) {
                        ForEach(UserProfile.Gender.allCases, id: \.self) { g in Text(g.rawValue).tag(g) }
                    }
                }
                Section {
                    Text("We use weight and gender to calculate your BAC more accurately! Click privacy to learn more.")
                        .font(.caption).foregroundColor(.gray)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { isPresented = false } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let weight = Double(editWeight) {
                            profileManager.updateProfile(name: editName, weight: weight, gender: editGender)
                        }
                        isPresented = false
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                editName   = profileManager.currentProfile.name
                editWeight = String(Int(profileManager.currentProfile.weight))
                editGender = profileManager.currentProfile.gender
            }
        }
    }
}

struct HouseView_Previews: PreviewProvider {
    static var previews: some View { ContentView() }
}
