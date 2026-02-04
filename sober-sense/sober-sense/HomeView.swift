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
                    
            HStack {
                Button {
                    
                } label: {
                    Text(Constants.startString)
                        .ghostButton()
                }
                    
                Button {
                        
                } label: {
                    Text(Constants.profileString)
                        .ghostButton()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
