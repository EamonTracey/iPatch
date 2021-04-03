//
//  RootViewModel.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import AppKit
import Combine

class RootViewModel: ObservableObject {
    @Published var debOrDylibURL = URL(fileURLWithPath: "")
    @Published var ipaURL = URL(fileURLWithPath: "")
    @Published var shouldInjectSubstrate = true
    @Published var successAlertPresented = false
    
    var readyToPatch: Bool {
        fileManager.filesExist(atFileURLS: [debOrDylibURL, ipaURL])
            && ![debOrDylibURL, ipaURL].contains(URL(fileURLWithPath: ""))
    }
    
    func patch() {
        guard readyToPatch else { return }
        let appURL = extractAppFromIPA(ipaURL)
        let binaryURL = extractBinaryFromApp(appURL)
        let dylibURL = debOrDylibURL.pathExtension == "deb" ? extractDylibFromDeb(debOrDylibURL) : debOrDylibURL
        patch_binary_with_dylib(binaryURL.path, dylibURL.path)
        insertDylibsDir(intoApp: appURL, withDylibs: [dylibURL])
        insertFrameworksDir(intoApp: appURL, withFrameworks: [])
        successAlertPresented = true
        saveFile(url: appToIPA(appURL), allowedFileTypes: ["ipa"])
    }
    
    func handleDrop(of providers: [NSItemProvider]) -> Bool {
        let _ = providers.first?.loadObject(ofClass: URL.self) { url, _  in
            switch url!.pathExtension {
            case "deb", "dylib":
                DispatchQueue.main.async {
                    self.debOrDylibURL = url!
                }
            case "ipa":
                DispatchQueue.main.async {
                    self.ipaURL = url!
                }
            default:
                NSSound.beep()
            }
        }
        return true
    }
}
