//
//  DiLaundryApp.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/6/23.
//

import SwiftUI
import CoreData

@main
struct DiLaundryApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            AppView()
        }
    }
}
