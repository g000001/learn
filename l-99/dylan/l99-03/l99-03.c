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

/* Define Generic element-at */

/* element-at is element-at */


/* Define Method element-at{<list>, <integer>} */

extern struct heapobj dylanZempty_list_ROOT;

extern descriptor_t l99_03Zliteral;	/* proxy for <integer> */

extern descriptor_t * dylanZdylan_visceraZgf_call_FUN(descriptor_t *orig_sp, heapptr_t A0, long A1);	/* gf-call */

extern struct heapobj l99_03Zl99_03Zelement_at_ROOT;

struct mv_result_0 {
    heapptr_t R0;
    heapptr_t R1;
};

extern struct mv_result_0 dylanZdylan_visceraZgf_call_lookup_FUN(descriptor_t *orig_sp, heapptr_t A0, long A1, descriptor_t A2);	/* gf-call-lookup */

extern struct heapobj l99_03Zstr_ROOT;

extern struct heapobj dylanZdylan_visceraZCLS_symbol_HEAP;

extern GD_NORETURN void dylanZdylan_visceraZtype_error_with_location_FUN(descriptor_t *orig_sp, descriptor_t A0, heapptr_t A1, descriptor_t A2);	/* type-error-with-location */

extern struct heapobj dylanZliteral_ROOT_56;

extern struct heapobj l99_03Zstr_ROOT_2;

/* element-at{<list>, <integer>} */
heapptr_t l99_03Zl99_03Zelement_at_METH(descriptor_t *orig_sp, heapptr_t A_sequence /* sequence */, long A_number /* number */, heapptr_t A2)
{
    descriptor_t *cluster_0_top;
    heapptr_t L_result; /* result */
    descriptor_t L_tail; /* tail */
    descriptor_t L_temp;
    descriptor_t L_temp_2;
    descriptor_t L_head; /* head */
    int L_temp_3; /* temp */
    descriptor_t L_temp_4;


    /* #line 22 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */

    /* #line 19 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
    if ((A_sequence == &dylanZempty_list_ROOT)) {

	/* #line 19 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
	L_result = obj_False;
    }
    else {
	/* #line {Class <unknown-source-location>} */

	/* #line 20 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
	if ((1 < A_number)) {

	    /* #line 21 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
	    L_tail = SLOT(A_sequence, descriptor_t, 12);

	    /* #line 21 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */

	    /* #line 21 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
	    L_temp.heapptr = l99_03Zliteral.heapptr;
	    L_temp.dataword.l = (A_number - 1);
	    orig_sp[0] = L_tail;
	    orig_sp[1] = L_temp;
	    /* element-at */
	    L_temp_2.heapptr = &l99_03Zstr_ROOT;
	    L_temp_2.dataword.l = 0;
	    {
	      struct mv_result_0 L_temp_gf_lookup = dylanZdylan_visceraZgf_call_lookup_FUN(orig_sp + 2, &l99_03Zl99_03Zelement_at_ROOT, 2, L_temp_2);
	      heapptr_t L_meth = L_temp_gf_lookup.R0;
	      heapptr_t L_next_info = L_temp_gf_lookup.R1;
	      cluster_0_top = GENERIC_ENTRY(L_meth)(orig_sp + 2, L_meth, 2, L_next_info);
	    }
	    L_result = orig_sp[0].heapptr;
	}
	else {

	    /* #line 20 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
	    L_head = SLOT(A_sequence, descriptor_t, 4);
	    if ((obj_False == L_head.heapptr)) {
		L_temp_3 = TRUE;
	    }
	    else {
		if ((&dylanZdylan_visceraZCLS_symbol_HEAP == SLOT(L_head.heapptr, heapptr_t, 0))) {
		    L_temp_3 = TRUE;
		}
		else {
		    L_temp_3 = FALSE;
		}
	    }
	    if (L_temp_3) {
		L_result = L_head.heapptr;
	    }
	    else {
		L_temp_4.heapptr = &l99_03Zstr_ROOT_2;
		L_temp_4.dataword.l = 0;
		/* type-error-with-location */
		dylanZdylan_visceraZtype_error_with_location_FUN(orig_sp, L_head, &dylanZliteral_ROOT_56, L_temp_4);
		not_reached();
	    }
	}
    }
    return L_result;
}

/* generic-entry for element-at{<list>, <integer>} */
descriptor_t * l99_03Zl99_03Zelement_at_METH_GENERIC(descriptor_t *orig_sp, heapptr_t A_self /* self */, long A_nargs /* nargs */, heapptr_t A_next_method_info /* next-method-info */)
{
    descriptor_t *cluster_0_top;
    void * L_args; /* args */
    descriptor_t L_arg; /* arg */
    descriptor_t L_arg_2; /* arg */
    heapptr_t L_result0; /* result0 */
    descriptor_t L_temp;


    /* #line 23 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
    L_args = ((void *)(orig_sp - 2));
    L_arg = (((descriptor_t *)L_args)[0]);
    L_arg_2 = (((descriptor_t *)L_args)[1]);
    orig_sp = L_args;
    /* element-at{<list>, <integer>} */
    L_result0 = l99_03Zl99_03Zelement_at_METH(orig_sp, L_arg.heapptr, L_arg_2.dataword.l, A_next_method_info);
    L_temp.heapptr = L_result0;
    L_temp.dataword.l = 0;
    orig_sp[0] = L_temp;
    return orig_sp + 1;
}


/* Top level form. */

extern struct heapobj l99_03Zliteral_ROOT;

extern descriptor_t standard_ioZstandard_ioZVstandard_outputV;	/* *standard-output* */

#include <stdlib.h>

extern heapptr_t dylanZdylan_visceraZCLS_simple_object_vector_MAKER_FUN(descriptor_t *orig_sp, long A0, descriptor_t A1);	/* maker for <simple-object-vector> */

extern void formatZformatZformat_METH(descriptor_t *orig_sp, heapptr_t A0, heapptr_t A1, heapptr_t A2, heapptr_t A3);	/* format{<buffered-stream>, <byte-string>} */

extern struct heapobj l99_03Zstr_ROOT_3;

extern struct heapobj l99_03Zliteral_ROOT_2;

/* form at "l99-03.dylan", line 45, characters 1 through 56:
    format-out("%=\n", element-at(#(a:, b:, c:, d:, e:), 3));
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   */
void l99_03ZLINE_45(descriptor_t *orig_sp)
{
    heapptr_t L_arg1; /* arg1 */
    descriptor_t L_temp;
    heapptr_t L_temp_2; /* temp */
    heapptr_t L_instance; /* instance */
    descriptor_t L_temp_3;

    /* #line {Class <unknown-source-location>} */

    /* #line 45 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
    /* element-at{<list>, <integer>} */
    L_arg1 = l99_03Zl99_03Zelement_at_METH(orig_sp, &l99_03Zliteral_ROOT, 3, &dylanZempty_list_ROOT);

    /* #line 45 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
    if ((L_temp = standard_ioZstandard_ioZVstandard_outputV).heapptr == NULL) abort();
    L_temp_2 = L_temp.heapptr;
    /* maker for <simple-object-vector> */
    L_instance = dylanZdylan_visceraZCLS_simple_object_vector_MAKER_FUN(orig_sp, 1, dylanZfalse);
    L_temp_3.heapptr = L_arg1;
    L_temp_3.dataword.l = 0;
    SLOT(L_instance, descriptor_t, 8 + 0 * sizeof(descriptor_t)) = L_temp_3;
    /* format{<buffered-stream>, <byte-string>} */
    formatZformatZformat_METH(orig_sp, L_temp_2, &l99_03Zstr_ROOT_3, &l99_03Zliteral_ROOT_2, L_instance);
    return;
}


/* Top level form. */

/* form at "l99-03.dylan", line 46, characters 1 through 38:
    format-out("%=\n", element-at(#(), 3));
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   */
void l99_03ZLINE_46(descriptor_t *orig_sp)
{
    heapptr_t L_arg1; /* arg1 */
    descriptor_t L_temp;
    heapptr_t L_temp_2; /* temp */
    heapptr_t L_instance; /* instance */
    descriptor_t L_temp_3;

    /* #line {Class <unknown-source-location>} */

    /* #line 46 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
    /* element-at{<list>, <integer>} */
    L_arg1 = l99_03Zl99_03Zelement_at_METH(orig_sp, &dylanZempty_list_ROOT, 3, &dylanZempty_list_ROOT);

    /* #line 46 "/u/mc/lisp/Work/L-99/l99-03/l99-03.dylan" */
    if ((L_temp = standard_ioZstandard_ioZVstandard_outputV).heapptr == NULL) abort();
    L_temp_2 = L_temp.heapptr;
    /* maker for <simple-object-vector> */
    L_instance = dylanZdylan_visceraZCLS_simple_object_vector_MAKER_FUN(orig_sp, 1, dylanZfalse);
    L_temp_3.heapptr = L_arg1;
    L_temp_3.dataword.l = 0;
    SLOT(L_instance, descriptor_t, 8 + 0 * sizeof(descriptor_t)) = L_temp_3;
    /* format{<buffered-stream>, <byte-string>} */
    formatZformatZformat_METH(orig_sp, L_temp_2, &l99_03Zstr_ROOT_3, &l99_03Zliteral_ROOT_2, L_instance);
    return;
}

