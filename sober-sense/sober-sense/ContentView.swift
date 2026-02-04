//
//  ContentView.swift
//  sober-sense
//
//  Created by Lucy Shah on 1/30/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Tab(Constants.homeString, systemImage: Constants.homeIconString){
                Text("Sober Sense")
            }
            Tab(Constants.dataString,systemImage: Constants.dataIconString){
                Text("Data")
            }
            Tab(Constants.profileString, systemImage: Constants.profileIconString){
                Text("Account")
            }
        }
    }
}

#Preview {
    ContentView()
}
