//
//  Constants.swift
//  sober-sense
//
//  Created by Lucy Shah on 2/3/26.
//
import Foundation
import SwiftUI

struct Constants {
    static let homeString: String = "Home"
    static let profileString: String = "Profile"
    static let dataString: String = "Data"
    static let startString = "start"
    
    
    static let homeIconString = "house"
    static let profileIconString = "person"
    static let dataIconString = "chart.bar"
    
    
    static let testTitleUrl = "https://image2url.com/r2/default/images/1770165050991-ace753c2-f93f-4df7-af5a-dff2d08894ff.jpg"
}


extension Text{
    func ghostButton() -> some View {
        self
            .frame(width: 100, height: 50)
            .foregroundStyle(.buttonText)
            .bold()
            .background{
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.buttonBorder,lineWidth: 5)

            }
    }
    func textUniversal() -> some View{
        self
            .foregroundStyle(.text)
            .font(.system(size: 22))
            .bold()
    }
    func numberText() -> some View{
        self
            .font(.system(size: 100))
            .bold()
        }
}
