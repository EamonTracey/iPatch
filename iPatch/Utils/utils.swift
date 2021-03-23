//
//  utils.swift
//  iPatch
//
//  Created by Eamon Tracey on 3/23/21.
//

import Foundation

let tmp = try! FileManager.default.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: .init(string: ".")!, create: true)

func shell(launchPath: String, arguments: [String]) {
    let process = Process()
    process.launchPath = launchPath
    process.arguments = arguments
    process.launch()
    process.waitUntilExit()
}

func extractDylibFromDeb(_ debURL: URL) -> URL {
    let tmpDebURL = tmp.appendingPathComponent("deb")
    shell(launchPath: "/usr/bin/ar", arguments: ["-x", debURL.path, tmpDebURL.path])
    let dylibDir = tmpDebURL.appendingPathComponent("Library/MobileSubstrate/DynamicLibraries").path
    guard let dylibDirEnum = FileManager.default.enumerator(atPath: dylibDir) else { fatalError() }
    guard let dylibPath = (dylibDirEnum.allObjects.filter {
        ($0 as! String).hasSuffix(".dylib")
    }.first as? String) else { fatalError() }
    return URL(string: "\(dylibDir)/\(dylibPath)")!
}

func extractAppFromIPA(_ ipaURL: URL) -> URL {
    let tmpIPAURL = tmp.appendingPathComponent("ipa")
    shell(launchPath: "/usr/bin/unzip", arguments: [ipaURL.path, tmpIPAURL.path])
    let appDir = tmpIPAURL.appendingPathComponent("Payload").path
    guard let appbDirEnum = FileManager.default.enumerator(atPath: appDir) else { fatalError() }
    guard let appPath = (appbDirEnum.allObjects.filter {
        ($0 as! String).hasSuffix(".dylib")
    }.first as? String) else { fatalError() }
    return URL(string: "\(appDir)/\(appPath)")!
}

func extractBinaryFromApp(_ appURL: URL) -> URL {
    fatalError()
}

func extractBinaryFromIPA(_ ipaURL: URL) -> URL {
    let appURL = extractAppFromIPA(ipaURL)
    let binaryURL = extractBinaryFromApp(appURL)
    return binaryURL
}
