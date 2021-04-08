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
            Text("Patching. This may take a while...")
            ProgressView()
                .progressViewStyle(LinearProgressViewStyle())
        }
        .padding()
    }
}
