//
//  Header.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct Header: View {
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Image(nsImage: NSApp.applicationIconImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("iPatch")
                    .fontWeight(.bold)
                    .font(.largeTitle)
            }
            Spacer()
        }
    }
}
