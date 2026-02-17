import SwiftUI

struct HouseView: View {
    @StateObject private var profileManager = ProfileManager()
    
    var body: some View {
        NavigationView {
            HomeView(profileManager: profileManager)
                .navigationTitle("Sober Sense")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HomeView: View {
    @ObservedObject var profileManager: ProfileManager
    
    var body: some View {
        VStack(spacing: 20) {
            // Top section with BAC
            VStack(spacing: 10) {
                Text("Your BAC is:")
                    .textUniversal()
                
                Text("0.00")
                    .numberText()
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Bottom buttons
            HStack(spacing: 20) {
                NavigationLink(destination: DataView()){
                    Text(Constants.dataString)
                        .ghostButton()
                        .offset(x: -30)
                }
                // Pass ProfileManager to ProfileView
                NavigationLink(destination: ProfileView(profileManager: profileManager)) {
                    Text(Constants.profileString)
                        .ghostButton()
                        .offset(x: 30)
                }
            }
            .padding(.bottom, 40)
        }
    }
}

struct ProfileView: View {
    @ObservedObject var profileManager: ProfileManager
    @State private var isEditingProfile = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Profile Header
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.buttonBorder.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.buttonBorder)
                    }
                    
                    Text(profileManager.currentProfile.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding(.top, 20)
                
                // Personal Information Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Personal Information")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        ProfileInfoRow(
                            label: "Name",
                            value: profileManager.currentProfile.name
                        )
                        Divider().padding(.leading)
                        ProfileInfoRow(
                            label: "Weight",
                            value: "\(Int(profileManager.currentProfile.weight)) lbs"
                        )
                        Divider().padding(.leading)
                        ProfileInfoRow(
                            label: "Gender",
                            value: profileManager.currentProfile.gender.rawValue
                        )
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // Edit Profile Button
                Button(action: {
                    isEditingProfile = true
                }) {
                    Text("Edit Profile")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.buttonBorder)  // Uses your app's accent color
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // App Settings Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Settings")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        SettingsRow(icon: "bell.fill", title: "Notifications", iconColor: Color("buttonBorder"), showChevron: true)
                        SettingsRow(icon: "lock.fill", title: "Privacy", iconColor: Color("buttonBorder"), showChevron: true)
                        SettingsRow(icon: "info.circle.fill", title: "About", iconColor: Color("buttonBorder"), showChevron: true)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Profile")
        .sheet(isPresented: $isEditingProfile) {
            EditProfileView(
                profileManager: profileManager,
                isPresented: $isEditingProfile
            )
        }
    }
}

struct ProfileInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
    }
}

// Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let showChevron: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .frame(width: 30)
            
            Text(title)
            
            Spacer()
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
        }
        .padding()
    }
}

// Edit Profile Sheet
struct EditProfileView: View {
    @ObservedObject var profileManager: ProfileManager
    @Binding var isPresented: Bool
    
    // Local state for editing
    @State private var editName: String = ""
    @State private var editWeight: String = ""
    @State private var editGender: UserProfile.Gender = .male
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Details")) {
                    TextField("Name", text: $editName)
                    
                    TextField("Weight (lbs)", text: $editWeight)
                        .keyboardType(.numberPad)
                    
                    Picker("Gender", selection: $editGender) {
                        ForEach(UserProfile.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                }
                
                Section {
                    Text("We use weight and gender to calculate your BAC more accurately! Click privacy to learn more.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save the changes to ProfileManager
                        if let weight = Double(editWeight) {
                            profileManager.updateProfile(
                                name: editName,
                                weight: weight,
                                gender: editGender
                            )
                        }
                        isPresented = false
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                // Load current values
                editName = profileManager.currentProfile.name
                editWeight = String(Int(profileManager.currentProfile.weight))
                editGender = profileManager.currentProfile.gender
            }
        }
    }
}

struct DataView: View{
    var body: some View{
        VStack {
            Text("History View")
                .textUniversal()
                .padding()
            Button ("Date"){
                print("you are an alchoholic")
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            .controlSize(.large)
            
            Spacer()
        }
        .navigationTitle("History")
    }
}

struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        HouseView()
    }
}
