//
//  utils.swift
//  iPatch
//
//  Created by Eamon Tracey on 3/23/21.
//

import Foundation

let tmp = try! FileManager.default.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: .init(string: ".")!, create: true)

func execShell(launchPath: String, arguments: [String]) {
    let process = Process()
    process.launchPath = launchPath
    process.arguments = arguments
    process.launch()
    process.waitUntilExit()
}

func convertDebToDylib(_ debURL: URL) -> URL {
    let tmpDebURL = tmp.appendingPathComponent("deb")
    execShell(launchPath: "/usr/bin/ar", arguments: ["-x", debURL.path, tmpDebURL.path])
    let dylibDir = tmpDebURL.appendingPathComponent("Library/MobileSubstrate/DynamicLibraries").path
    guard let dylibDirEnum = FileManager.default.enumerator(atPath: dylibDir) else { fatalError() }
    guard let dylibPath = (dylibDirEnum.allObjects.filter {
        ($0 as! String).hasSuffix(".dylib")
    }.first as? String) else { fatalError() }
    return URL(string: "\(dylibDir)/\(dylibPath)")!
}

func convertIPAToBinary(_ ipaURL: URL) -> URL {
    let tmpIPAURL = tmp.appendingPathComponent("ipa")
    execShell(launchPath: "/usr/bin/unzip", arguments: [ipaURL.path, tmpIPAURL.path])
    let appDir = tmpIPAURL.appendingPathComponent("Payload")
    fatalError()
}
