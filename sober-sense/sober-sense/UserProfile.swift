//
//  UserProfile.swift
//  sober-sense
//
//  Created by Lucy Shah on 2/16/26.
//

import Foundation
import SwiftUI
import Combine

struct UserProfile: Codable {
    var name: String
    var weight: Double // in pounds
    var gender: Gender
    
    enum Gender: String, Codable, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
        
        //from what I can tell this is how BAC calculation works for m/f
        // bacConstant is the r value in the forumla
        
        var bacConstant: Double {
            switch self{
            case .male:
                return 0.68
            case .female:
                return 0.55
            case .other:
                return 0.62 // this the average
            }
        }
    }
    
    static let defaultProfile = UserProfile (
        name: "User",
        weight: 150.0,
        gender: .other
    )
}

// this deals with saving/loading
class ProfileManager: ObservableObject {
    @Published var currentProfile: UserProfile
    
    private let userDefaultsKey = "userProfile"
    
    init() {
        // Load saved profile or use default
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.currentProfile = profile
        } else {
            self.currentProfile = UserProfile.defaultProfile
        }
    }
    
    // Save profile to UserDefaults
    func saveProfile() {
        if let encoded = try? JSONEncoder().encode(currentProfile) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    // Update profile fields
    func updateProfile(name: String, weight: Double, gender: UserProfile.Gender) {
        currentProfile.name = name
        currentProfile.weight = weight
        currentProfile.gender = gender
        saveProfile()
    }
    
    // Calculate BAC (basic Widmark formula)
    func calculateBAC(alcoholGrams: Double, hoursElapsed: Double) -> Double {
        let bodyWeightGrams = currentProfile.weight * 453.592  // lbs to grams
        let bac = (alcoholGrams / (bodyWeightGrams * currentProfile.gender.bacConstant)) * 100
        let eliminatedBAC = hoursElapsed * 0.015  // Standard elimination rate
        return max(0, bac - eliminatedBAC)
    }
}
