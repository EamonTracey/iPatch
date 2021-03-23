//
//  URLText.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct URLText: View {
    let url: URL
    @State private var sheetPresented = false
    
    var body: some View {
        Text(url.lastPathComponent)
            .onTapGesture { sheetPresented = true }
            .popover(isPresented: $sheetPresented, arrowEdge: .bottom) {
                Text(url.path)
                    .padding()
            }
    }
}

