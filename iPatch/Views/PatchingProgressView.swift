//
//  PatchingProgressView.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct PatchingProgressView: View {
    var body: some View {
        VStack {
            Text("Patching. This will take many seconds...")
            ProgressView()
                .progressViewStyle(LinearProgressViewStyle())
        }
        .padding()
    }
}
