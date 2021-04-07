//
//  patch.swift
//  iPatch
//
//  Created by Eamon Tracey on 3/25/21.
//

import Foundation

func patch(ipa ipaURL: URL, withDebOrDylib debOrDylibURL: URL, andDisplayName displayName: String) {
    let appURL = extractAppFromIPA(ipaURL)
    let binaryURL = extractBinaryFromApp(appURL)
    let dylibURL = debOrDylibURL.pathExtension == "deb" ? extractDylibFromDeb(debOrDylibURL) : debOrDylibURL
    insertDylibsDir(intoApp: appURL, withDylib: dylibURL)
    insertSubstrateDylibs(intoApp: appURL)
    patch_binary_with_dylib(binaryURL.path, dylibURL.lastPathComponent, true)
    changeDisplayName(ofApp: appURL, to: displayName)
    saveFile(url: appToIPA(appURL), allowedFileTypes: ["app"])
}

func insertDylibsDir(intoApp appURL: URL, withDylib dylibURL: URL) {
    let dylibsDir = appURL.appendingPathComponent("iPatchDylibs")
    let newDylibURL = dylibsDir.appendingPathComponent(dylibURL.lastPathComponent)
    try? fileManager.createDirectory(at: dylibsDir, withIntermediateDirectories: false, attributes: .none)
    try! fileManager.copyItem(at: dylibURL, to: newDylibURL)
    shell(launchPath: "/usr/bin/install_name_tool", arguments: ["-id", "@executable_path/iPatchDylibs/\(dylibURL.lastPathComponent)", newDylibURL.path])
}

func insertSubstrateDylibs(intoApp appURL: URL) {
    let dylibsDir = appURL.appendingPathComponent("iPatchDylibs")
    try! fileManager.copyItem(at: bundle.url(forResource: "libblackjack", withExtension: "dylib")!, to: dylibsDir.appendingPathComponent("libblackjack.dylib"))
    try! fileManager.copyItem(at: bundle.url(forResource: "libhooker", withExtension: "dylib")!, to: dylibsDir.appendingPathComponent("libhooker.dylib"))
    try! fileManager.copyItem(at: bundle.url(forResource: "libsubstrate", withExtension: "dylib")!, to: dylibsDir.appendingPathComponent("libsubtrate.dylib"))
}

func changeDisplayName(ofApp appURL: URL, to displayName: String) {
    let infoURL = appURL.appendingPathComponent("Info.plist")
    let info = NSDictionary(contentsOf: infoURL)!
    info.setValue(displayName, forKey: "CFBundleDisplayName")
    info.write(to: infoURL, atomically: true)
}
