//
//  utils.swift
//  iPatch
//
//  Created by Eamon Tracey.
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
    shell(launchPath: "/usr/local/bin/dpkg-deb", arguments: ["-x", debURL.path, tmpDebURL.path])
    let dylibDir = tmpDebURL.appendingPathComponent("Library/MobileSubstrate/DynamicLibraries").path
    guard let dylibDirEnum = FileManager.default.enumerator(atPath: dylibDir) else { fatalError() }
    guard let dylibPath = (dylibDirEnum.allObjects.filter {
        ($0 as! String).hasSuffix(".dylib")
    }.first as? String) else { fatalError() }
    return URL(fileURLWithPath: "\(dylibDir)/\(dylibPath)")
}

func extractAppFromIPA(_ ipaURL: URL) -> URL {
    let tmpIPAURL = tmp.appendingPathComponent("ipa")
    shell(launchPath: "/usr/bin/unzip", arguments: [ipaURL.path, "-d", tmpIPAURL.path])
    let appDir = tmpIPAURL.appendingPathComponent("Payload").path
    guard let appDirEnum = FileManager.default.enumerator(atPath: appDir) else { fatalError() }
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

func extractBinaryFromIPA(_ ipaURL: URL) -> URL {
    let appURL = extractAppFromIPA(ipaURL)
    let binaryURL = extractBinaryFromApp(appURL)
    return binaryURL
}
