#import "NSData+Reading.h"
#import <objc/runtime.h>

@implementation NSData (Reading)

static char OFFSET;
- (NSUInteger)currentOffset {
    NSNumber *value = objc_getAssociatedObject(self, &OFFSET);
    return value.unsignedIntegerValue;
}

- (void)setCurrentOffset:(NSUInteger)offset {
    [self willChangeValueForKey:@"currentOffset"];
    objc_setAssociatedObject(self, &OFFSET, [NSNumber numberWithUnsignedInteger:offset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"currentOffset"];
}

- (uint32_t)intAtOffset:(NSUInteger)offset {
    uint32_t result;
    [self getBytes:&result range:NSMakeRange(offset, sizeof(result))];
    return result;
}

@end
