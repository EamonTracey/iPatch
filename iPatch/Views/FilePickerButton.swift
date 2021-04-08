//
//  FilePickerButton.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import AppKit
import SwiftUI

struct FilePickerButton: View {
    let title: String
    @Binding var selection: URL?
    let extensions: [String]
    
    init(_ title: String, selection: Binding<URL?>, extensions: [String]) {
        self.title = title
        self._selection = selection
        self.extensions = extensions
    }
    
    var body: some View {
        Button(title, action: openFile)
            .onDrop(of: [.fileURL], isTargeted: .none) { providers in
                let _ = providers.first?.loadObject(ofClass: URL.self) { url, _  in
                    if extensions.contains(url!.pathExtension) {
                        DispatchQueue.main.async {
                            selection = url!
                        }
                    } else {
                        NSSound.beep()
                    }
                }
                return true
            }
    }
    
    private func openFile() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = extensions
        panel.begin { response in
            if response == .OK {
                selection = panel.url!
            }
        }
    }
}
