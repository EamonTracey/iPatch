//
//  SubstrateInfo.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct SubstrateInfo: View {
    var body: some View {
        Text("iPatch supports injecting libsubstrate, libblackjack, and libhooker into IPAs. This feature is meant to be used when injecting substrate tweak dylibs into an IPA. If you are injecting an app tweak, toggle this option on. Otherwise, toggle it off.")
            .padding()
            .frame(width: 200, height: 200)
    }
}
