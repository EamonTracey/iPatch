//
//  patch.swift
//  iPatch
//
//  Created by Eamon Tracey on 3/25/21.
//

import Foundation

func patch(ipa ipaURL: URL, withDebOrDylib debOrDylibURL: URL, andDisplayName displayName: String, injectSubstrate: Bool) {
    let appURL = extractAppFromIPA(ipaURL)
    let binaryURL = extractBinaryFromApp(appURL)
    let dylibURL = debOrDylibURL.pathExtension == "deb" ? extractDylibFromDeb(debOrDylibURL) : debOrDylibURL
    insertDylibsDir(intoApp: appURL, withDylib: dylibURL, injectSubstrate: injectSubstrate)
    if !patch_binary_with_dylib(binaryURL.path, dylibURL.lastPathComponent, injectSubstrate) {
        
    }
    changeDisplayName(ofApp: appURL, to: displayName)
    saveFile(url: appToIPA(appURL), withPotentialName: displayName, allowedFileTypes: ["ipa"]) {
        DispatchQueue.main.async {
            try? fileManager.removeItem(at: tmp)
        }
    }
}

func insertDylibsDir(intoApp appURL: URL, withDylib dylibURL: URL, injectSubstrate: Bool) {
    let dylibsDir = appURL.appendingPathComponent("iPatchDylibs")
    let newDylibURL = dylibsDir.appendingPathComponent(dylibURL.lastPathComponent)
    try? fileManager.createDirectory(at: dylibsDir, withIntermediateDirectories: false, attributes: .none)
    fatalTry("Failed to copy dylib \(dylibURL.path) to app iPatchDylibs directory \(dylibsDir.path)") {
        try fileManager.copyItem(at: dylibURL, to: newDylibURL)
    }
    shell(launchPath: "/usr/bin/install_name_tool", arguments: ["-id", "@executable_path/iPatchDylibs/\(dylibURL.lastPathComponent)", newDylibURL.path])
    if injectSubstrate {
        shell(launchPath: "/usr/bin/install_name_tool", arguments: ["-change", "/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", "@executable_path/iPatchDylibs/libsubstrate.dylib", newDylibURL.path])
        insertSubstrateDylibs(intoApp: appURL)
    }
}

func insertSubstrateDylibs(intoApp appURL: URL) {
    let dylibsDir = appURL.appendingPathComponent("iPatchDylibs")
    fatalTry("Failed to copy libblackjack, libhooker, and libsubstrate to app iPatchDylibs directory \(dylibsDir.path)") {
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
