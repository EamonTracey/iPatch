#import <mach-o/loader.h>

struct thin_header {
    uint32_t offset;
    uint32_t size;
    struct mach_header header;
};
