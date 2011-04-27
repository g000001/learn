#include <stddef.h>

#define GD_HAVE_LONG_LONG
#include "runtime.h"

extern descriptor_t dylanZtrue;	/* #t */

#define obj_True dylanZtrue.heapptr
extern descriptor_t dylanZfalse;	/* #f */

#define obj_False dylanZfalse.heapptr

#define GENERAL_ENTRY(func) \
    ((entry_t)SLOT(func, void *, 8))
#define GENERIC_ENTRY(func) \
    ((entry_t)SLOT(func, void *, 32))

#define GD_CTASSERT(name, x) \
    typedef char gd_assert_ ## name[(x) ? 1 : -1];
#define GD_VERIFY_SIZE_ASSUMPTION(name, type, size)\
    GD_CTASSERT(size_ ## name, sizeof(type) == (size))
#define GD_VERIFY_ALIGN_ASSUMPTION(name, type, align)\
    typedef struct { char c; type x; } \
      gd_align_ ## name; \
    GD_CTASSERT(align_ ## name, offsetof(gd_align_ ## name, x) == (align))

GD_VERIFY_SIZE_ASSUMPTION(general, descriptor_t, 8);
GD_VERIFY_ALIGN_ASSUMPTION(general, descriptor_t, 4);
GD_VERIFY_SIZE_ASSUMPTION(heap, heapptr_t, 4);
GD_VERIFY_ALIGN_ASSUMPTION(heap, heapptr_t, 4);
GD_VERIFY_SIZE_ASSUMPTION(boolean, int, 4);
GD_VERIFY_ALIGN_ASSUMPTION(boolean, int, 4);
GD_VERIFY_SIZE_ASSUMPTION(long_long, long long, 8);
GD_VERIFY_ALIGN_ASSUMPTION(long_long, long long, 4);
GD_VERIFY_SIZE_ASSUMPTION(long, long, 4);
GD_VERIFY_ALIGN_ASSUMPTION(long, long, 4);
GD_VERIFY_SIZE_ASSUMPTION(int, int, 4);
GD_VERIFY_ALIGN_ASSUMPTION(int, int, 4);
GD_VERIFY_SIZE_ASSUMPTION(uint, unsigned int, 4);
GD_VERIFY_ALIGN_ASSUMPTION(uint, unsigned int, 4);
GD_VERIFY_SIZE_ASSUMPTION(short, short, 2);
GD_VERIFY_ALIGN_ASSUMPTION(short, short, 2);
GD_VERIFY_SIZE_ASSUMPTION(ushort, unsigned short, 2);
GD_VERIFY_ALIGN_ASSUMPTION(ushort, unsigned short, 2);
GD_VERIFY_SIZE_ASSUMPTION(float, float, 4);
GD_VERIFY_ALIGN_ASSUMPTION(float, float, 4);
GD_VERIFY_SIZE_ASSUMPTION(double, double, 8);
GD_VERIFY_ALIGN_ASSUMPTION(double, double, 4);
GD_VERIFY_SIZE_ASSUMPTION(long_double, long double, 16);
GD_VERIFY_ALIGN_ASSUMPTION(long_double, long double, 16);
GD_VERIFY_SIZE_ASSUMPTION(ptr, void *, 4);
GD_VERIFY_ALIGN_ASSUMPTION(ptr, void *, 4);

/* Define Library l99-03. */


/* Define Module l99-03. */

