//
//  RootView.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct RootView: View {
    @State private var debOrDylibURL = URL(string: "_")!
    @State private var ipaURL = URL(string: "_")!
    @State private var injectCydiaSubstrate = true
    @State private var successAlertPresented = false
    private var readyToPatch: Bool { FileManager.default.filesExist(atFileURLS: [debOrDylibURL, ipaURL]) }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    HStack {
                        Image(systemName: "hammer")
                        Text("iPatch")
                            .fontWeight(.bold)
                    }
                    .font(.largeTitle)
                    Spacer()
                }
                Spacer()
                HStack {
                    DocumentPickerButton("DEB/Dylib", selection: $debOrDylibURL, extensions: ["deb", "dylib"])
                    URLText(url: debOrDylibURL)
                }
                HStack {
                    DocumentPickerButton("IPA", selection: $ipaURL, extensions: ["ipa"])
                    URLText(url: ipaURL)
                        .offset(x: 40)
                }
                Toggle("Inject CydiaSubstrate", isOn: $injectCydiaSubstrate)
                Spacer()
                HStack {
                    Spacer()
                    Button("Patch", action: patch)
                        .disabled(!readyToPatch)
                        .buttonStyle(PatchButtonStyle())
                    Spacer()
                }
                Spacer()
                Text("Eamon Tracey © 2021")
            }
            Spacer()
        }
        .padding()
        .alert(isPresented: $successAlertPresented) {
            Alert(title: Text("iPatch Sucess!"), message: Text("Successfully injected \(debOrDylibURL.path) into \(ipaURL.path)"))
        }
        .onDrop(of: [.fileURL], isTargeted: .none) { providers in
            let _ = providers.first?.loadObject(ofClass: URL.self) { url, _  in
                switch url!.pathExtension {
                case "deb", "dylib":
                    debOrDylibURL = url!
                case "ipa":
                    ipaURL = url!
                default:
                    NSSound.beep()
                }
            }
            return true
        }
    }
    
    private func patch() {
        guard readyToPatch else { return }
        let binaryURL = extractBinaryFromIPA(ipaURL)
        let dylibURL = debOrDylibURL.pathExtension == "deb" ? extractDylibFromDeb(debOrDylibURL) : debOrDylibURL
        patch_binary_with_dylib(binaryURL.path, dylibURL.path, injectCydiaSubstrate)
        successAlertPresented = true
    }
}
