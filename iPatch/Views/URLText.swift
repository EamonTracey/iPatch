//
//  URLText.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct URLText: View {
    let url: URL
    @State private var popoverPresented = false
    
    var body: some View {
        Text(url.lastPathComponent)
            .onTapGesture { popoverPresented = true }
            .popover(isPresented: $popoverPresented, arrowEdge: .bottom) {
                Text(url.path)
                    .padding()
            }
    }
}
