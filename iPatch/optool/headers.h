#import <Foundation/Foundation.h>
#import "defines.h"

#define SWAP(NUM) shouldSwap ? CFSwapInt32(NUM) : NUM

struct thin_header headerAtOffset(NSData *binary, uint32_t offset);
struct thin_header *headersFromBinary(struct thin_header *headers, NSData *binary, uint32_t *amount);
