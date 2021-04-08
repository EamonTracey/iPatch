//
//  shell.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

func shell(launchPath: String, arguments: [String]) {
    let process = Process()
    process.launchPath = launchPath
    process.arguments = arguments
    process.launch()
    process.waitUntilExit()
}
