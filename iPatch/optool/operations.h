#import <Foundation/Foundation.h>
#import "defines.h"

BOOL stripCodeSignatureFromBinary(NSMutableData *binary, struct thin_header macho, BOOL soft);
BOOL unrestrictBinary(NSMutableData *binary, struct thin_header macho, BOOL soft);
BOOL removeLoadEntryFromBinary(NSMutableData *binary, struct thin_header macho, NSString *payload);
BOOL binaryHasLoadCommandForDylib(NSMutableData *binary, NSString *dylib, uint32_t *lastOffset, struct thin_header macho);
BOOL insertLoadEntryIntoBinary(NSString *dylibPath, NSMutableData *binary, struct thin_header macho, uint32_t type);
BOOL removeASLRFromBinary(NSMutableData *binary, struct thin_header macho);
BOOL renameBinary(NSMutableData *binary, struct thin_header macho, NSString *from, NSString *to);
