#import "headers.h"
#import <mach-o/loader.h>
#import <mach-o/fat.h>
#import "NSData+Reading.h"

struct thin_header headerAtOffset(NSData *binary, uint32_t offset) {
    struct thin_header macho;
    macho.offset = offset;
    macho.header = *(struct mach_header *)(binary.bytes + offset);
    if (macho.header.magic == MH_MAGIC || macho.header.magic == MH_CIGAM) {
        macho.size = sizeof(struct mach_header);
    } else {
        macho.size = sizeof(struct mach_header_64);
    }
    if (macho.header.cputype != CPU_TYPE_X86_64 && macho.header.cputype != CPU_TYPE_I386 && macho.header.cputype != CPU_TYPE_ARM && macho.header.cputype != CPU_TYPE_ARM64) {
        macho.size = 0;
    }
    return macho;
}

struct thin_header *headersFromBinary(struct thin_header *headers, NSData *binary, uint32_t *amount) {
    uint32_t magic = [binary intAtOffset:0];
    bool shouldSwap = magic == MH_CIGAM || magic == MH_CIGAM_64 || magic == FAT_CIGAM;
    uint32_t numArchs = 0;
    if (magic == FAT_CIGAM || magic == FAT_MAGIC) {
        struct fat_header fat = *(struct fat_header *)binary.bytes;
        fat.nfat_arch = SWAP(fat.nfat_arch);
        int offset = sizeof(struct fat_header);
        for (int i = 0; i < fat.nfat_arch; i++) {
            struct fat_arch arch;
            arch = *(struct fat_arch *)([binary bytes] + offset);
            arch.cputype = SWAP(arch.cputype);
            arch.offset = SWAP(arch.offset);
            struct thin_header macho = headerAtOffset(binary, arch.offset);
            if (macho.size > 0) {
                headers[numArchs] = macho;
                numArchs++;
            }
            offset += sizeof(struct fat_arch);
        }
    } else if (magic == MH_MAGIC || magic == MH_MAGIC_64) {
        struct thin_header macho = headerAtOffset(binary, 0);
        if (macho.size > 0) {
            numArchs++;
            headers[0] = macho;
        }
    }
    *amount = numArchs;
    return headers;
}
