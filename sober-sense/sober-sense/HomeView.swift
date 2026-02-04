//
//  HomeView.swift
//  sober-sense
//
//  Created by Lucy Shah on 2/3/26.
//

import SwiftUI

struct HomeView: View {
    
    var testTitleUrl = Constants.testTitleUrl
    
    
    var body: some View {

        VStack {
            
            Text("Your BAC is: ")
                .textUniversal()
                .position(x: 200, y: 200)
            Text("0.00")
                .numberText()
                .position(x: 200, y: 15)
                
            Spacer()
            HStack {
                Button {
                    
                } label: {
                    Text(Constants.startString)
                        .ghostButton()
                        .position(x: 100, y: 225)
                }
                    
                Button {
                        
                } label: {
                    Text(Constants.profileString)
                        .ghostButton()
                        .position(x: 100, y: 225)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
