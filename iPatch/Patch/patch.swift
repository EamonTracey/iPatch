//
//  patch.swift
//  iPatch
//
//  Created by Eamon Tracey on 3/25/21.
//

import Foundation

func insertiPatchDylibsDir(intoApp appURL: URL, withDylibs dylibURLs: [URL]) {
    let dylibsDir = appURL.appendingPathComponent("iPatchDylibs")
    try? fileManager.createDirectory(at: dylibsDir, withIntermediateDirectories: false, attributes: .none)
    for dylibURL in dylibURLs {
        shell(launchPath: "/usr/bin/install_name_tool", arguments: ["-id", "@executable_path/iPatchDylibs/\(dylibURL.lastPathComponent)", dylibURL.path])
        try! fileManager.copyItem(at: dylibURL, to: dylibsDir.appendingPathComponent(dylibURL.lastPathComponent))
    }
}
