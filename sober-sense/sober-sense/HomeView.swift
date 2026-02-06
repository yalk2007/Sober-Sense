//
//  HomeView.swift
//  sober-sense
//
//  Created by Lucy Shah on 2/3/26.
//

import SwiftUI

struct HouseView: View {
    var body: some View {
        NavigationView {
            HomeView()
                .navigationTitle("Sober Sense")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct HomeView: View {
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
                NavigationLink(destination: ProfileView()) {
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
    var body: some View {
        VStack {
            Text("Profile Page")
                .textUniversal()
                .padding()
            
            Spacer()
        }
        .navigationTitle("Profile")
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
