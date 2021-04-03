//
//  patch.swift
//  iPatch
//
//  Created by Eamon Tracey on 3/25/21.
//

import Foundation

func insertDylibsDir(intoApp appURL: URL, withDylibs dylibURLs: [URL]) {
    let dylibsDir = appURL.appendingPathComponent("Dylibs")
    try? fileManager.createDirectory(at: dylibsDir, withIntermediateDirectories: false, attributes: .none)
    for dylibURL in dylibURLs {
        shell(launchPath: "/usr/bin/install_name_tool", arguments: ["-id", "@executable_path/Dylibs/\(dylibURL.lastPathComponent)", dylibURL.path])
        try! fileManager.copyItem(at: dylibURL, to: dylibsDir.appendingPathComponent(dylibURL.lastPathComponent))
    }
}

func insertFrameworksDir(intoApp appURL: URL, withFrameworks frameworkURLs: [URL]) {
    let frameworksDir = appURL.appendingPathComponent("Frameworks")
    try? fileManager.createDirectory(at: frameworksDir, withIntermediateDirectories: false, attributes: .none)
    for frameworkURL in frameworkURLs {
        shell(launchPath: "/usr/bin/install_name_tool", arguments: ["-id", "@executable_path/Frameworks/\(frameworkURL.lastPathComponent)", frameworkURL.path])
        try! fileManager.copyItem(at: frameworkURL, to: frameworksDir.appendingPathComponent(frameworkURL.lastPathComponent))
    }
}
