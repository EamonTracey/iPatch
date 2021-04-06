#import <mach-o/loader.h>

#ifndef CPU_TYPE_ARM64
#define CPU_TYPE_ARM64 (CPU_TYPE_ARM | CPU_ARCH_ABI64)
#endif

#define LOG(fmt, args...) printf(fmt "\n", ##args)

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

// we pass around this header which includes some extra information
// and a 32-bit header which we used for both 32-bit and 64-bit files
// since the 64-bit just adds an extra field to the end which we don't need
struct thin_header {
    uint32_t offset;
    uint32_t size;
    struct mach_header header;
};

typedef NS_ENUM(int, OPError) {
    OPErrorNone               = 0,
    OPErrorRead               = 1,           // failed to read target path
    OPErrorIncompatibleBinary = 2,           // couldn't find x86 or x86_64 architecture in binary
    OPErrorStripFailure       = 3,           // failed to strip codesignature
    OPErrorWriteFailure       = 4,           // failed to write data to final output path
    OPErrorNoBackup           = 5,           // no backup to restore
    OPErrorRemovalFailure     = 6,           // failed to remove executable during restore
    OPErrorMoveFailure        = 7,           // failed to move backup to correct location
    OPErrorNoEntries          = 8,           // cant remove dylib entries because they dont exist
    OPErrorInsertFailure      = 9,           // failed to insert load command
    OPErrorInvalidLoadCommand = 10,          // user provided an unnacceptable load command string
    OPErrorResignFailure      = 11,          // codesign failed for some reason
    OPErrorBackupFailure      = 12,          // failed to write backup
    OPErrorInvalidArguments   = 13,          // bad arguments
    OPErrorBadULEB            = 14,          // uleb while reading binding ordinals is in an invalid format
    OPErrorULEBEncodeFailure  = 15           // failed to encode a uleb within specified length requirements
};
