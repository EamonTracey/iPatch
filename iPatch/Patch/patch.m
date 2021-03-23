//
//  patch.m
//  iPatch
//
//  Created by Eamon Tracey on 3/22/21.
//

#include "patch.h"

int patch_binary_with_dylib(NSString *binaryPath, NSString *dylibPath, BOOL shouldInjectSubstrate) {
    // Create a tmp directory
    NSString *tmpPath = [[[NSFileManager defaultManager] URLForDirectory:NSItemReplacementDirectory inDomain:NSUserDomainMask appropriateForURL:[[NSURL alloc] initWithString:@"."] create:true error:nil] path];
    
    // Extract binary data
    NSData *originalData = [NSData dataWithContentsOfFile:binaryPath];
    NSMutableData *binary = [originalData mutableCopy];
    
    // Extract binary headers
    struct thin_header headers[4];
    uint32_t numHeaders = 0;
    headersFromBinary(headers, binary, &numHeaders);
    if (numHeaders == 0) {
        return PatchFailure;
    }
    
    // Successful patch
    return PatchSuccess;
}
