//
//  fatal.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import AppKit

func fatalTry(_ errorMessage: String, closure: @escaping () throws -> ()) {
    do {
        try closure()
    } catch {
        fatalExit(errorMessage)
    }
}

func fatalExit(_ errorMessage: String) -> Never {
    let alert = NSAlert()
    alert.alertStyle = .critical
    alert.messageText = "iPatch Fatal Error"
    alert.informativeText = errorMessage
    alert.addButton(withTitle: "Exit")
    alert.runModal()
    fatalError(errorMessage)
}
