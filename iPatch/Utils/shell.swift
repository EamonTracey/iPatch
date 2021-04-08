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
    if process.terminationStatus != 0 {
        fatalExit("Command with launch path \(launchPath) and arguments \(arguments) in working directory \(fileManager.currentDirectoryPath) failed with termination status \(process.terminationStatus).")
    }
}
