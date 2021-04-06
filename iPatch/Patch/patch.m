//
//  patch.m
//  iPatch
//
//  Created by Eamon Tracey.
//

#include "patch.h"

PatchResult patch_binary_with_dylib(NSString *binaryPath, NSString *dylibName) {
    // Extract binary data
    NSMutableData *binary = [NSMutableData dataWithContentsOfFile:binaryPath];

    // Extract binary headers
    struct thin_header headers[4];
    uint32_t numHeaders = 0;
    headersFromBinary(headers, binary, &numHeaders);
    
    // Loop through headers
    for (uint32_t i = 0; i < numHeaders; i++) {
        struct thin_header macho = headers[i];
        // Insert dylib load entry into binary
        insertLoadEntryIntoBinary([NSString stringWithFormat:@"@executable_path/iPatchDylibs/%@", dylibName], binary, macho, LC_LOAD_DYLIB);
    }
    
    // Write binary to original binary path
    [binary writeToFile:binaryPath atomically:NO];

    // Successful patch
    return PatchSuccess;
}

