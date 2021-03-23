//
//  patch.h
//  iPatch
//
//  Created by Eamon Tracey on 3/22/21.
//

#import <Foundation/Foundation.h>
#import "../optool/headers.h"
#import "../optool/operations.h"

typedef enum: int {
    PatchSuccess,
    PatchFailure
} PatchResult;

int patch_binary_with_dylib(NSString *binaryPath, NSString *dylibPath, BOOL shouldInjectSubstrate);
