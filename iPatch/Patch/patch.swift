//
//  patch.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import Foundation

enum PatchResult {
    case success, failure
}

func patchBinary(_ binaryPath: String, withDylib dylibPath: String) -> PatchResult {
    // Extract binary data
    let originalData = NSData(contentsOfFile: binaryPath)!
    let binary = originalData.mutableCopy() as! NSMutableData
    
    // Extract binary headers
    let headers = UnsafeMutablePointer<thin_header>.allocate(capacity: 4)
    var numHeaders = UInt32()
    headersFromBinary(headers, binary as Data, &numHeaders)
    
    // Successful patch
    return .success
}

