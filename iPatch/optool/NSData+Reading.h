#import <Foundation/Foundation.h>

@interface NSData (Reading)

- (NSUInteger)currentOffset;
- (void)setCurrentOffset:(NSUInteger)offset;

- (uint8_t)nextByte;
- (uint8_t)byteAtOffset:(NSUInteger)offset;

- (uint16_t)nextShort;
- (uint16_t)shortAtOffset:(NSUInteger)offset;

- (uint32_t)nextInt;
- (uint32_t)intAtOffset:(NSUInteger)offset;

- (uint64_t)nextLong;
- (uint64_t)longAtOffset:(NSUInteger)offset;

@end
