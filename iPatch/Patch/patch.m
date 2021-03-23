//
//  patch.m
//  iPatch
//
//  Created by Eamon Tracey on 3/22/21.
//

#include "patch.h"

int patch_ipa_with_dylib(NSString *ipaPath, NSString *dylibPath, BOOL shouldInjectSubstrate) {
    NSLog(@"Dylib Path: %@", dylibPath);
    
    // Create a tmp directory
    NSString *tmpPath = [[[NSFileManager defaultManager] URLForDirectory:NSItemReplacementDirectory inDomain:NSUserDomainMask appropriateForURL:[[NSURL alloc] initWithString:@"."] create:true error:nil] path];
    
    // Extract .app path from IPA
    NSString *appPath = @"";
    
    // Extract app binary path from .app
    NSString *binaryPath = @"";
    
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
