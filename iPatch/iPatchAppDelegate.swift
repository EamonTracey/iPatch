//
//  iPatchAppDelegate.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

class iPatchAppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        validateDependencies()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        try? iPatch.fileManager.removeItem(at: tmp)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
