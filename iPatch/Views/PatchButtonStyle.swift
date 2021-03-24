//
//  PatchButtonStyle.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct PatchButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        PatchButton(configuration: configuration)
    }
    
    private struct PatchButton: View {
        let configuration: ButtonStyle.Configuration
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .padding(.vertical)
                .padding(.horizontal, 40)
                .background(Color.accentColor)
                .clipShape(Capsule())
                .opacity(isEnabled && !configuration.isPressed ? 1 : 0.5)
        }
    }
}
