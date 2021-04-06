//
//  iPatchApp.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

@main
struct iPatchApp: App {
    @NSApplicationDelegateAdaptor(iPatchAppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .frame(width: 400, height: 350)
        }
    }
}
