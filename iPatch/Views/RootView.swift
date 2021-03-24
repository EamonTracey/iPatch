//
//  RootView.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct RootView: View {
    @StateObject private var vm = RootViewModel()
    
    var body: some View {
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
                DocumentPickerButton("DEB/Dylib", selection: $vm.debOrDylibURL, extensions: ["deb", "dylib"])
                URLText(url: vm.debOrDylibURL)
            }
            HStack {
                DocumentPickerButton("IPA", selection: $vm.ipaURL, extensions: ["ipa"])
                URLText(url: vm.ipaURL)
                    .offset(x: 40)
            }
            Toggle("Inject CydiaSubstrate", isOn: $vm.injectCydiaSubstrate)
            Spacer()
            HStack {
                Spacer()
                Button("Patch", action: vm.patch)
                    .disabled(!vm.readyToPatch)
                    .buttonStyle(PatchButtonStyle())
                Spacer()
            }
            Spacer()
            Text("Eamon Tracey © 2021")
        }
        .padding()
        .onDrop(of: [.fileURL], isTargeted: .none) { providers in vm.handleDrop(of: providers) }
        .alert(isPresented: $vm.successAlertPresented) {
            Alert(title: Text("iPatch Sucess!"), message: Text("Successfully injected \(vm.debOrDylibURL.path) into \(vm.ipaURL.path)"))
        }
    }
}
