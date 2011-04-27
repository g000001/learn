# Makefile for compiling the .c and .s files
# If you want to compile .dylan files, don't use this makefile.

CCFLAGS = -I. -I/usr/local/include -Os -fomit-frame-pointer -no-cpp-precomp -Wno-long-double
LIBTOOL = glibtool
GC_LIBS = -lgc -ldl -lpthread
# We only know the ultimate target when we've finished building the rest
# of this makefile.  So we use this fake target...
#
all : all-at-end-of-file

l99-03-exports.o : l99-03-exports.c
	gcc $(CCFLAGS) -c l99-03-exports.c -o l99-03-exports.o
l99-03.o : l99-03.c
	gcc $(CCFLAGS) -c l99-03.c -o l99-03.o
l99-03-init.o : l99-03-init.c
	gcc $(CCFLAGS) -c l99-03-init.c -o l99-03-init.o
l99-03-heap.o : l99-03-heap.c
	gcc $(CCFLAGS) -c l99-03-heap.c -o l99-03-heap.o
l99-03-global-heap.o : l99-03-global-heap.c
	gcc $(CCFLAGS) -c l99-03-global-heap.c -o l99-03-global-heap.o
l99-03-global-inits.o : l99-03-global-inits.c
	gcc $(CCFLAGS) -c l99-03-global-inits.c -o l99-03-global-inits.o

l99-03 :  l99-03-exports.o l99-03.o l99-03-init.o l99-03-heap.o l99-03-global-heap.o l99-03-global-inits.o
	$(LIBTOOL) --mode=link gcc -o l99-03  l99-03-exports.o l99-03.o l99-03-init.o l99-03-heap.o l99-03-global-heap.o l99-03-global-inits.o  /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libio-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libformat-out-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libstandard-io-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libformat-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libprint-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libcommon-dylan-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/librandom-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libtranscendental-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libtable-extensions-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libthreads-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libstreams-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libmelange-support-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libdylan-dylan.a /usr/local/lib/dylan/2.4.1pre1/ppc-darwin-gcc4/libruntime.a  $(GC_LIBS) -multiply_defined suppress

all-at-end-of-file : l99-03

clean :
	rm -f  l99-03-exports.o l99-03.o l99-03-init.o l99-03-heap.o l99-03-global-heap.o l99-03-global-inits.o l99-03

realclean :
	rm -f  cc-l99-03-files.mak l99-03-exports.o l99-03-exports.c l99-03.o l99-03.c l99-03-init.o l99-03-init.c l99-03-heap.o l99-03-heap.c l99-03-global-heap.o l99-03-global-heap.c l99-03-global-inits.o l99-03-global-inits.c l99-03
