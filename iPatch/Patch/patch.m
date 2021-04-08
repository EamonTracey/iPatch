//
//  patch.m
//  iPatch
//
//  Created by Eamon Tracey.
//

#include "patch.h"

BOOL patch_binary_with_dylib(NSString *binaryPath, NSString *dylibName, BOOL injectSubstrate) {
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
        if (!insertLoadEntryIntoBinary([NSString stringWithFormat:@"@executable_path/iPatchDylibs/%@", dylibName], binary, macho, LC_LOAD_DYLIB)) {
            return NO;
        }
    }
    
    // Write binary to original binary path
    [binary writeToFile:binaryPath atomically:NO];
    
    // Insert libsubstrate load command
    // Only the libsubstrate load command is necessary
    // because libsubstrate loads libblackjack and libhooker
    if (injectSubstrate) {
        patch_binary_with_dylib(binaryPath, @"libsubstrate.dylib", false);
    }

    // Successful patch
    return YES;
}
