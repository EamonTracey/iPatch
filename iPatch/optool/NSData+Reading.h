#import <Foundation/Foundation.h>

@interface NSData (Reading)
- (NSUInteger)currentOffset;
- (void)setCurrentOffset:(NSUInteger)offset;
- (uint32_t)intAtOffset:(NSUInteger)offset;
@end
