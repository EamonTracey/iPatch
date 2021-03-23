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

int patch_ipa_with_dylib(NSString *ipa, NSString *dylib, BOOL shouldInjectSubstrate);
