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
    @Published var displayName = ""
    @Published var successAlertPresented = false
    
    var readyToPatch: Bool {
        fileManager.filesExist(atFileURLS: [debOrDylibURL, ipaURL])
            && ![debOrDylibURL, ipaURL].contains(URL(fileURLWithPath: ""))
    }
    
    func patch() {
        guard readyToPatch else { return }
        iPatch.patch(ipa: ipaURL, withDebOrDylib: debOrDylibURL, andDisplayName: displayName)
        successAlertPresented = true
    }
    
    func ipaURLDidChange() {
        displayName = ipaURL.deletingPathExtension().lastPathComponent
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
