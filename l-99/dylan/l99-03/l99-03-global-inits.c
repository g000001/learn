#include "runtime.h"
#include <stdlib.h>

/* This file is machine generated.  Do not edit. */

void inits(descriptor_t *sp, int argc, char *argv[])
{
    dylan_Library_init(sp);
    melange_support_Library_init(sp);
    streams_Library_init(sp);
    threads_Library_init(sp);
    table_extensions_Library_init(sp);
    transcendental_Library_init(sp);
    random_Library_init(sp);
    common_dylan_Library_init(sp);
    print_Library_init(sp);
    format_Library_init(sp);
    standard_io_Library_init(sp);
    format_out_Library_init(sp);
    io_Library_init(sp);
    l99_03_Library_init(sp);
}

extern void real_main(int argc, char *argv[]);

int main(int argc, char *argv[]) {
    real_main(argc, argv);
    exit(0);
}
