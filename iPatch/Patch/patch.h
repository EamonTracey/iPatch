//
//  patch.h
//  iPatch
//
//  Created by Eamon Tracey.
//

#import <Foundation/Foundation.h>
#import "../optool/headers.h"
#import "../optool/operations.h"

typedef enum: int {
    PatchSuccess,
    PatchFailure,
} PatchResult;

PatchResult patch_binary_with_dylib(NSString *binaryPath, NSString *dylibPath, BOOL injectSubstrate);
