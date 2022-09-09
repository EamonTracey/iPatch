//
//  RootViewModel.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import AppKit
import Combine

class RootViewModel: ObservableObject {
    @Published var debOrDylibURL: URL? = nil
    @Published var ipaURL: URL? = nil
    @Published var injectSubstrate = true
    @Published var displayName = ""
    @Published var bundleID = ""
    @Published var substratePopoverPresented = false
    @Published var isPatching = false
    
    var readyToPatch: Bool {
        ![debOrDylibURL, ipaURL].contains(nil)
            && fileManager.filesExist(atFileURLS: [debOrDylibURL!, ipaURL!])
    }
    
    func patch() {
        guard readyToPatch else { return }
        isPatching = true
        iPatch.patch(ipa: ipaURL!, withDebOrDylib: debOrDylibURL!, andDisplayName: displayName, andBundleID: bundleID, injectSubstrate: injectSubstrate)
        isPatching = false
    }
    
    func ipaURLDidChange() {
        displayName = ipaURL!.deletingPathExtension().lastPathComponent
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
