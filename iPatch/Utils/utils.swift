//
//  utils.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import AppKit
import Foundation

let fileManager = FileManager.default
let tmp = try! fileManager.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: .init(string: ".")!, create: true)

func shell(launchPath: String, arguments: [String]) {
    let process = Process()
    process.launchPath = launchPath
    process.arguments = arguments
    process.launch()
    process.waitUntilExit()
}

func extractDylibFromDeb(_ debURL: URL) -> URL {
    let tmpDebDir = tmp.appendingPathComponent("deb")
    shell(launchPath: "/usr/local/bin/dpkg-deb", arguments: ["-x", debURL.path, tmpDebDir.path])
    let dylibDir = tmpDebDir.appendingPathComponent("Library/MobileSubstrate/DynamicLibraries").path
    guard let dylibDirEnum = fileManager.enumerator(atPath: dylibDir) else { fatalError() }
    guard let dylibPath = (dylibDirEnum.allObjects.filter {
        ($0 as! String).hasSuffix(".dylib")
    }.first as? String) else { fatalError() }
    return URL(fileURLWithPath: "\(dylibDir)/\(dylibPath)")
}

func extractAppFromIPA(_ ipaURL: URL) -> URL {
    let tmpOldIPADir = tmp.appendingPathComponent("oldipa")
    shell(launchPath: "/usr/bin/unzip", arguments: [ipaURL.path, "-d", tmpOldIPADir.path])
    let appDir = tmpOldIPADir.appendingPathComponent("Payload").path
    guard let appDirEnum = fileManager.enumerator(atPath: appDir) else { fatalError() }
    guard let appPath = (appDirEnum.allObjects.filter {
        ($0 as! String).hasSuffix(".app")
    }.first as? String) else { fatalError() }
    return URL(fileURLWithPath: "\(appDir)/\(appPath)")
}

func extractBinaryFromApp(_ appURL: URL) -> URL {
    let infoURL = appURL.appendingPathComponent("Info.plist")
    let info = NSDictionary(contentsOf: infoURL)!
    let executableName = info["CFBundleExecutable"] as! String
    return appURL.appendingPathComponent(executableName)
}

func appToIPA(_ appURL: URL) -> URL {
    return appURL
}

func saveFile(url: URL, allowedFileTypes: [String]) {
    let savePanel = NSSavePanel()
    savePanel.allowedFileTypes = allowedFileTypes
    savePanel.begin { result in
        if result == .OK {
            try! fileManager.moveItem(at: url, to: savePanel.url!)
        }
    }
}
