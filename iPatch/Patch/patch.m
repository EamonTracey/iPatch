//
//  patch.m
//  iPatch
//
//  Created by Eamon Tracey.
//

#include "patch.h"

PatchResult patch_binary_with_dylib(NSString *binaryPath, NSString *dylibPath, BOOL shouldInjectSubstrate) {
    // Extract binary data
    NSMutableData *binary = [NSMutableData dataWithContentsOfFile:binaryPath];

    // Extract binary headers
    struct thin_header headers[4];
    uint32_t numHeaders = 0;
    headersFromBinary(headers, binary, &numHeaders);
    
    // Loop through headers, inserting binary load entry into each
    for (uint32_t i = 0; i < numHeaders; i++) {
        struct thin_header macho = headers[i];
        insertLoadEntryIntoBinary(dylibPath, binary, macho, LC_LOAD_DYLIB);
    }

    // Successful patch
    return PatchSuccess;
}

