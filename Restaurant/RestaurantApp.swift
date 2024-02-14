//
//  RestaurantApp.swift
//  Restaurant
//
//  Created by John Tejada on 2/8/24.
//

import SwiftUI

@main
struct RestaurantApp: App {
    var userInfo = UserInformation()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userInfo)
        }
    }
}

