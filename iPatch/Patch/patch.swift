//
//  patch.swift
//  iPatch
//
//  Created by Eamon Tracey on 3/25/21.
//

import Foundation

let bundle = Bundle.main

func patch(ipa ipaURL: URL, withDebOrDylib debOrDylibURL: URL, andDisplayName displayName: String, injectSubstrate: Bool) {
    try? fileManager.removeItem(at: tmp)
    try? fileManager.createDirectory(at: tmp, withIntermediateDirectories: false, attributes: .none)
    let appURL = extractAppFromIPA(ipaURL)
    let binaryURL = extractBinaryFromApp(appURL)
    let dylibURL = debOrDylibURL.pathExtension == "deb" ? extractDylibFromDeb(debOrDylibURL) : debOrDylibURL
    insertDylibsDir(intoApp: appURL, withDylib: dylibURL, injectSubstrate: injectSubstrate)
    if !patch_binary_with_dylib(binaryURL.path, dylibURL.lastPathComponent, injectSubstrate) {
        fatalExit("Unable to patch app binary at \(binaryURL.path). The binary may be malformed.")
    }
    changeDisplayName(ofApp: appURL, to: displayName)
    saveFile(url: appToIPA(appURL), withPotentialName: displayName, allowedFileTypes: ["ipa"])
}

func insertDylibsDir(intoApp appURL: URL, withDylib dylibURL: URL, injectSubstrate: Bool) {
    let dylibsDir = appURL.appendingPathComponent("iPatchDylibs")
    let newDylibURL = dylibsDir.appendingPathComponent(dylibURL.lastPathComponent)
    try? fileManager.createDirectory(at: dylibsDir, withIntermediateDirectories: false, attributes: .none)
    fatalTry("Failed to copy dylib \(dylibURL.path) to app iPatchDylibs directory \(dylibsDir.path).") {
        try fileManager.copyItem(at: dylibURL, to: newDylibURL)
    }
    shell(launchPath: INSTALL_NAME_TOOL, arguments: ["-id", "\(EXECIPATCHDYLIBS)/\(dylibURL.lastPathComponent)", newDylibURL.path])
    if injectSubstrate {
        shell(launchPath: INSTALL_NAME_TOOL, arguments: ["-change", "/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", "\(EXECIPATCHDYLIBS)/libsubstrate.dylib", newDylibURL.path])
        insertSubstrateDylibs(intoApp: appURL)
    }
}

func insertSubstrateDylibs(intoApp appURL: URL) {
    let dylibsDir = appURL.appendingPathComponent("iPatchDylibs")
    fatalTry("Failed to copy libblackjack, libhooker, and libsubstrate to app iPatchDylibs directory \(dylibsDir.path).") {
        try fileManager.copyItem(at: bundle.url(forResource: "libblackjack", withExtension: "dylib")!, to: dylibsDir.appendingPathComponent("libblackjack.dylib"))
        try fileManager.copyItem(at: bundle.url(forResource: "libhooker", withExtension: "dylib")!, to: dylibsDir.appendingPathComponent("libhooker.dylib"))
        try fileManager.copyItem(at: bundle.url(forResource: "libsubstrate", withExtension: "dylib")!, to: dylibsDir.appendingPathComponent("libsubstrate.dylib"))
    }
}

func changeDisplayName(ofApp appURL: URL, to displayName: String) {
    let infoURL = appURL.appendingPathComponent("Info.plist")
    let info = NSDictionary(contentsOf: infoURL)!
    info.setValue(displayName, forKey: "CFBundleDisplayName")
    info.write(to: infoURL, atomically: true)
}
