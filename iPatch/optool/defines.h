#import <mach-o/loader.h>

#ifndef CPU_TYPE_ARM64
#define CPU_TYPE_ARM64 (CPU_TYPE_ARM | CPU_ARCH_ABI64)
#endif

#define CPU(CPUTYPE) ({ \
const char *c = ""; \
if (CPUTYPE == CPU_TYPE_I386) \
c = "x86"; \
if (CPUTYPE == CPU_TYPE_X86_64) \
c = "x86_64"; \
if (CPUTYPE == CPU_TYPE_ARM) \
c = "arm"; \
if (CPUTYPE == CPU_TYPE_ARM64) \
c = "arm64"; \
c; \
})

#define LC(LOADCOMMAND) ({ \
const char *c = ""; \
if (LOADCOMMAND == LC_REEXPORT_DYLIB) \
c = "LC_REEXPORT_DYLIB";\
else if (LOADCOMMAND == LC_LOAD_WEAK_DYLIB) \
c = "LC_LOAD_WEAK_DYLIB";\
else if (LOADCOMMAND == LC_LOAD_UPWARD_DYLIB) \
c = "LC_LOAD_UPWARD_DYLIB";\
else if (LOADCOMMAND == LC_LOAD_DYLIB) \
c = "LC_LOAD_DYLIB";\
c;\
})

struct thin_header {
    uint32_t offset;
    uint32_t size;
    struct mach_header header;
};
