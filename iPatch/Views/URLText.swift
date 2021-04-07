//
//  URLText.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct URLText: View {
    let url: URL?
    @State private var popoverPresented = false
    
    var body: some View {
        Text(url?.lastPathComponent ?? "Choose one")
            .onTapGesture { popoverPresented = true }
            .popover(isPresented: $popoverPresented) {
                Text(url?.path ?? "")
                    .padding()
            }
    }
}
