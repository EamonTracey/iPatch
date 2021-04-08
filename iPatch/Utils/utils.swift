//
//  utils.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import AppKit
import Foundation

let fileManager = FileManager.default
let bundle = Bundle.main
let tmp = try! fileManager.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: .init(string: ".")!, create: true)

func shell(launchPath: String, arguments: [String]) {
    let process = Process()
    process.launchPath = launchPath
    process.arguments = arguments
    process.launch()
    process.waitUntilExit()
}

func extractDylibFromDeb(_ debURL: URL) -> URL {
    let debDir = tmp.appendingPathComponent("deb")
    shell(launchPath: "/usr/local/bin/dpkg-deb", arguments: ["-x", debURL.path, debDir.path])
    let dylibDirPath = debDir.appendingPathComponent("Library/MobileSubstrate/DynamicLibraries").path
    guard let dylibDirEnum = fileManager.enumerator(atPath: dylibDirPath) else { fatalError() }
    guard let dylibPath = (dylibDirEnum.allObjects.filter {
        ($0 as! String).hasSuffix(".dylib")
    }.first as? String) else { fatalError() }
    return URL(fileURLWithPath: "\(dylibDirPath)/\(dylibPath)")
}

func extractAppFromIPA(_ ipaURL: URL) -> URL {
    let oldIPADir = tmp.appendingPathComponent("oldipa")
    shell(launchPath: "/usr/bin/unzip", arguments: [ipaURL.path, "-d", oldIPADir.path])
    let appDirPath = oldIPADir.appendingPathComponent("Payload").path
    guard let appDirEnum = fileManager.enumerator(atPath: appDirPath) else { fatalError() }
    guard let appPath = (appDirEnum.allObjects.filter {
        ($0 as! String).hasSuffix(".app")
    }.first as? String) else { fatalError() }
    return URL(fileURLWithPath: "\(appDirPath)/\(appPath)")
}

func extractBinaryFromApp(_ appURL: URL) -> URL {
    let infoURL = appURL.appendingPathComponent("Info.plist")
    let info = NSDictionary(contentsOf: infoURL)!
    let executableName = info["CFBundleExecutable"] as! String
    return appURL.appendingPathComponent(executableName)
}

func appToIPA(_ appURL: URL) -> URL {
    let newIPADir = tmp.appendingPathComponent("newipa")
    let payloadDir = newIPADir.appendingPathComponent("Payload")
    fatalTry("Failed to copy app \(appURL.path) to new IPA payload directory \(payloadDir.path)") {
        try fileManager.createDirectory(at: payloadDir, withIntermediateDirectories: true, attributes: .none)
        try fileManager.copyItem(at: appURL, to: payloadDir.appendingPathComponent(appURL.lastPathComponent))
    }
    fileManager.changeCurrentDirectoryPath(newIPADir.path )
    shell(launchPath: "/usr/bin/zip", arguments: ["-r", "newipa.ipa", "Payload"])
    return newIPADir.appendingPathComponent("newipa.ipa")
}

func saveFile(url: URL, withPotentialName potentialName: String, allowedFileTypes: [String], completionHandler: @escaping () -> ()) {
    let savePanel = NSSavePanel()
    savePanel.nameFieldStringValue = potentialName
    savePanel.allowedFileTypes = allowedFileTypes
    savePanel.begin { result in
        if result == .OK {
            fatalTry("Failed to move IPA file \(url.path) to desired location \(savePanel.url!.path)") {
                try fileManager.moveItem(at: url, to: savePanel.url!)
            }
        }
        completionHandler()
    }
}

func fatalTry(_ errorMessage: String, closure: @escaping () throws -> ()) {
    do {
        try closure()
    } catch {
        let alert = NSAlert()
        alert.alertStyle = .critical
        alert.messageText = "iPatch Fatal Error"
        alert.informativeText = errorMessage
        alert.addButton(withTitle: "Exit")
        alert.runModal()
        NSApp.terminate(nil)
    }
}
