#include "runtime.h"


extern heapptr_t l99_03_L0;

descriptor_t l99_03Zliteral =
    { (heapptr_t) &l99_03_L0, { 0 } } /* roots[0] */;


/* heap base */

/* proxy for <integer> */
extern struct dylanZdylan_visceraZCLS_class {
    heapptr_t PCTobject_class;	 /* %object-class */
    heapptr_t class_name;	 /* class-name */
    long unique_id;	 /* unique-id */
    heapptr_t direct_superclasses;	 /* direct-superclasses */
    heapptr_t all_superclasses;	 /* all-superclasses */
    heapptr_t closest_primary_superclass;	 /* closest-primary-superclass */
    heapptr_t direct_subclasses;	 /* direct-subclasses */
    char class_functionalQUERY;	 /* class-functional? */
    char class_primaryQUERY;	 /* class-primary? */
    char class_abstractQUERY;	 /* class-abstract? */
    char class_sealedQUERY;	 /* class-sealed? */
    heapptr_t class_deferred_evaluations;	 /* class-deferred-evaluations */
    heapptr_t class_key_defaulter;	 /* class-key-defaulter */
    heapptr_t class_maker;	 /* class-maker */
    heapptr_t class_new_slot_descriptors;	 /* class-new-slot-descriptors */
    heapptr_t class_slot_overrides;	 /* class-slot-overrides */
    heapptr_t class_all_slot_descriptors;	 /* class-all-slot-descriptors */
    long class_bucket;	 /* class-bucket */
    heapptr_t class_row;	 /* class-row */
} dylanZdylan_visceraZCLS_integer_HEAP;

heapptr_t l99_03_L0 =
(heapptr_t) &dylanZdylan_visceraZCLS_integer_HEAP /* %object-class */;

/* element-at */
extern struct dylanZdylan_visceraZCLS_class dylanZdylan_visceraZCLS_generic_function_HEAP;

extern const struct dylanZdylan_visceraZCLS_byte_string_SIZE10 {
    heapptr_t PCTobject_class;	 /* %object-class */
    long size;	 /* size */
    unsigned char PCTelement[10];	 /* %element */
} l99_03_L1;

extern descriptor_t * dylanZdylan_visceraZgf_call_FUN(descriptor_t *orig_sp, heapptr_t A0, long A1);	/* gf-call */

extern struct dylanZdylan_visceraZCLS_simple_object_vector_SIZE2 {
    heapptr_t PCTobject_class;	 /* %object-class */
    long size;	 /* size */
    descriptor_t PCTelement[2];	 /* %element */
} l99_03_L2;

extern struct dylanZdylan_visceraZCLS_false {
    heapptr_t PCTobject_class;	 /* %object-class */
} dylan_L1;

extern struct dylanZdylan_visceraZCLS_simple_object_vector_SIZE1 {
    heapptr_t PCTobject_class;	 /* %object-class */
    long size;	 /* size */
    descriptor_t PCTelement[1];	 /* %element */
} l99_03_L3;

extern struct dylanZdylan_visceraZCLS_union {
    heapptr_t PCTobject_class;	 /* %object-class */
    heapptr_t union_members;	 /* union-members */
    heapptr_t union_singletons;	 /* union-singletons */
} dylanZliteral_ROOT_38;

extern struct dylanZdylan_visceraZCLS_pair {
    heapptr_t PCTobject_class;	 /* %object-class */
    descriptor_t head;	 /* head */
    descriptor_t tail;	 /* tail */
} l99_03_L4;

struct dylanZdylan_visceraZCLS_generic_function {
    heapptr_t PCTobject_class;	 /* %object-class */
    heapptr_t function_name;	 /* function-name */
    void * general_entry;	 /* general-entry */
    heapptr_t function_specializers;	 /* function-specializers */
    char function_restQUERY;	 /* function-rest? */
    char function_all_keysQUERY;	 /* function-all-keys? */
    unsigned char HOLE1[2];
    heapptr_t function_keywords;	 /* function-keywords */
    heapptr_t function_values;	 /* function-values */
    heapptr_t function_rest_value;	 /* function-rest-value */
    heapptr_t generic_function_methods;	 /* generic-function-methods */
    heapptr_t method_cache;	 /* method-cache */
} l99_03Zl99_03Zelement_at_ROOT = {
(heapptr_t) &dylanZdylan_visceraZCLS_generic_function_HEAP /* %object-class */,
    (heapptr_t) &l99_03_L1 /* function-name */,
    dylanZdylan_visceraZgf_call_FUN /* general-entry */,
    (heapptr_t) &l99_03_L2 /* function-specializers */,
    0 /* function-rest? */,
    0 /* function-all-keys? */,
    { 0, 0, }, /* hole */
    (heapptr_t) &dylan_L1 /* function-keywords */,
    (heapptr_t) &l99_03_L3 /* function-values */,
    (heapptr_t) &dylanZliteral_ROOT_38 /* function-rest-value */,
    (heapptr_t) &l99_03_L4 /* generic-function-methods */,
    (heapptr_t) &dylan_L1 /* method-cache */,
};

/* "\"l99-03.dylan\", line 21, characters 18 through 55:\n        otherwise => element-at(tail(sequence), number - 1);\n                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n  " */
extern struct dylanZdylan_visceraZCLS_class dylanZdylan_visceraZCLS_byte_string_HEAP;

const struct dylanZdylan_visceraZCLS_byte_string_SIZE174 {
    heapptr_t PCTobject_class;	 /* %object-class */
    long size;	 /* size */
    unsigned char PCTelement[174];	 /* %element */
} l99_03Zstr_ROOT = {
    (heapptr_t) &dylanZdylan_visceraZCLS_byte_string_HEAP /* %object-class */,
    174 /* size */,
    "\"l99-03.dylan\", line 21, characters 18 through 55:\n        otherwise => element-at(tail(sequence), number - 1);\n                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n  ",
};

/* "\"l99-03.dylan\", line 20, characters 20 through 33:\n        1 >= number => head(sequence);\n                       ^^^^^^^^^^^^^^\n  " */
const struct dylanZdylan_visceraZCLS_byte_string_SIZE130 {
    heapptr_t PCTobject_class;	 /* %object-class */
    long size;	 /* size */
    unsigned char PCTelement[130];	 /* %element */
} l99_03Zstr_ROOT_2 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_byte_string_HEAP /* %object-class */,
    130 /* size */,
    "\"l99-03.dylan\", line 20, characters 20 through 33:\n        1 >= number => head(sequence);\n                       ^^^^^^^^^^^^^^\n  ",
};

/* {a <pair>} */
extern struct dylanZdylan_visceraZCLS_class dylanZdylan_visceraZCLS_pair_HEAP;

extern struct dylanZdylan_visceraZCLS_symbol {
    heapptr_t PCTobject_class;	 /* %object-class */
    descriptor_t symbol_string;	 /* symbol-string */
    long symbol_hashing;	 /* symbol-hashing */
    heapptr_t symbol_next;	 /* symbol-next */
} SYM_a_HEAP;

extern struct dylanZdylan_visceraZCLS_pair l99_03_L6;

struct dylanZdylan_visceraZCLS_pair l99_03Zliteral_ROOT = {
    (heapptr_t) &dylanZdylan_visceraZCLS_pair_HEAP /* %object-class */,
    { (heapptr_t) &SYM_a_HEAP, { 0 } } /* head */,
    { (heapptr_t) &l99_03_L6, { 0 } } /* tail */,
};

/* "%=\n" */
const struct dylanZdylan_visceraZCLS_byte_string_SIZE3 {
    heapptr_t PCTobject_class;	 /* %object-class */
    long size;	 /* size */
    unsigned char PCTelement[3];	 /* %element */
} l99_03Zstr_ROOT_3 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_byte_string_HEAP /* %object-class */,
    3 /* size */,
    "%=\n",
};

/* {a <pair>} */
extern struct dylanZdylan_visceraZCLS_method {
    heapptr_t PCTobject_class;	 /* %object-class */
    heapptr_t function_name;	 /* function-name */
    void * general_entry;	 /* general-entry */
    heapptr_t function_specializers;	 /* function-specializers */
    char function_restQUERY;	 /* function-rest? */
    char function_all_keysQUERY;	 /* function-all-keys? */
    unsigned char HOLE1[2];
    heapptr_t function_keywords;	 /* function-keywords */
    heapptr_t function_values;	 /* function-values */
    heapptr_t function_rest_value;	 /* function-rest-value */
    void * generic_entry;	 /* generic-entry */
} format_L118;

extern struct dylanZdylan_visceraZCLS_empty_list {
    heapptr_t PCTobject_class;	 /* %object-class */
    descriptor_t head;	 /* head */
    descriptor_t tail;	 /* tail */
} dylanZempty_list_ROOT;

struct dylanZdylan_visceraZCLS_pair l99_03Zliteral_ROOT_2 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_pair_HEAP /* %object-class */,
    { (heapptr_t) &format_L118, { 0 } } /* head */,
    { (heapptr_t) &dylanZempty_list_ROOT, { 0 } } /* tail */,
};

/* "element-at" */
const struct dylanZdylan_visceraZCLS_byte_string_SIZE10 l99_03_L1 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_byte_string_HEAP /* %object-class */,
    10 /* size */,
    "element-at",
};

/* {a <simple-object-vector>} */
extern struct dylanZdylan_visceraZCLS_class dylanZdylan_visceraZCLS_simple_object_vector_HEAP;

extern struct dylanZdylan_visceraZCLS_class dylanZdylan_visceraZCLS_sequence_HEAP;

struct dylanZdylan_visceraZCLS_simple_object_vector_SIZE2 l99_03_L2 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_simple_object_vector_HEAP /* %object-class */,
    2 /* size */,
    {
	{ (heapptr_t) &dylanZdylan_visceraZCLS_sequence_HEAP, { 0 } } /* %element[0] */,
	{ (heapptr_t) &dylanZdylan_visceraZCLS_integer_HEAP, { 0 } } /* %element[1] */,
    },
};

/* {a <simple-object-vector>} */
extern struct dylanZdylan_visceraZCLS_union dylanZliteral_ROOT_56;

struct dylanZdylan_visceraZCLS_simple_object_vector_SIZE1 l99_03_L3 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_simple_object_vector_HEAP /* %object-class */,
    1 /* size */,
    {
	{ (heapptr_t) &dylanZliteral_ROOT_56, { 0 } } /* %element[0] */,
    },
};

/* {a <pair>} */
extern struct dylanZdylan_visceraZCLS_method l99_03_L7;

struct dylanZdylan_visceraZCLS_pair l99_03_L4 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_pair_HEAP /* %object-class */,
    { (heapptr_t) &l99_03_L7, { 0 } } /* head */,
    { (heapptr_t) &dylanZempty_list_ROOT, { 0 } } /* tail */,
};

/* {a <pair>} */
extern struct dylanZdylan_visceraZCLS_symbol SYM_b_HEAP;

extern struct dylanZdylan_visceraZCLS_pair l99_03_L9;

struct dylanZdylan_visceraZCLS_pair l99_03_L6 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_pair_HEAP /* %object-class */,
    { (heapptr_t) &SYM_b_HEAP, { 0 } } /* head */,
    { (heapptr_t) &l99_03_L9, { 0 } } /* tail */,
};

/* element-at{<list>, <integer>} */
extern struct dylanZdylan_visceraZCLS_class dylanZdylan_visceraZCLS_method_HEAP;

extern const struct dylanZdylan_visceraZCLS_byte_string_SIZE29 {
    heapptr_t PCTobject_class;	 /* %object-class */
    long size;	 /* size */
    unsigned char PCTelement[29];	 /* %element */
} l99_03_L10;

extern descriptor_t * dylanZdylan_visceraZgeneral_call_FUN(descriptor_t *orig_sp, heapptr_t A0, long A1);	/* general-call */

extern struct dylanZdylan_visceraZCLS_simple_object_vector_SIZE2 l99_03_L11;

extern descriptor_t * l99_03Zl99_03Zelement_at_METH_GENERIC(descriptor_t *orig_sp, heapptr_t A0 /* self */, long A1 /* nargs */, heapptr_t A2 /* next-info */);

struct dylanZdylan_visceraZCLS_method l99_03_L7 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_method_HEAP /* %object-class */,
    (heapptr_t) &l99_03_L10 /* function-name */,
    dylanZdylan_visceraZgeneral_call_FUN /* general-entry */,
    (heapptr_t) &l99_03_L11 /* function-specializers */,
    0 /* function-rest? */,
    0 /* function-all-keys? */,
    { 0, 0, }, /* hole */
    (heapptr_t) &dylan_L1 /* function-keywords */,
    (heapptr_t) &l99_03_L3 /* function-values */,
    (heapptr_t) &dylanZliteral_ROOT_38 /* function-rest-value */,
    l99_03Zl99_03Zelement_at_METH_GENERIC /* generic-entry */,
};

/* {a <pair>} */
extern struct dylanZdylan_visceraZCLS_symbol SYM_c_HEAP;

extern struct dylanZdylan_visceraZCLS_pair l99_03_L13;

struct dylanZdylan_visceraZCLS_pair l99_03_L9 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_pair_HEAP /* %object-class */,
    { (heapptr_t) &SYM_c_HEAP, { 0 } } /* head */,
    { (heapptr_t) &l99_03_L13, { 0 } } /* tail */,
};

/* "element-at{<list>, <integer>}" */
const struct dylanZdylan_visceraZCLS_byte_string_SIZE29 l99_03_L10 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_byte_string_HEAP /* %object-class */,
    29 /* size */,
    "element-at{<list>, <integer>}",
};

/* {a <simple-object-vector>} */
extern struct dylanZdylan_visceraZCLS_class dylanZdylan_visceraZCLS_list_HEAP;

struct dylanZdylan_visceraZCLS_simple_object_vector_SIZE2 l99_03_L11 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_simple_object_vector_HEAP /* %object-class */,
    2 /* size */,
    {
	{ (heapptr_t) &dylanZdylan_visceraZCLS_list_HEAP, { 0 } } /* %element[0] */,
	{ (heapptr_t) &dylanZdylan_visceraZCLS_integer_HEAP, { 0 } } /* %element[1] */,
    },
};

/* {a <pair>} */
extern struct dylanZdylan_visceraZCLS_symbol SYM_d_HEAP;

extern struct dylanZdylan_visceraZCLS_pair l99_03_L15;

struct dylanZdylan_visceraZCLS_pair l99_03_L13 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_pair_HEAP /* %object-class */,
    { (heapptr_t) &SYM_d_HEAP, { 0 } } /* head */,
    { (heapptr_t) &l99_03_L15, { 0 } } /* tail */,
};

/* {a <pair>} */
extern struct dylanZdylan_visceraZCLS_symbol SYM_e_HEAP;

struct dylanZdylan_visceraZCLS_pair l99_03_L15 = {
    (heapptr_t) &dylanZdylan_visceraZCLS_pair_HEAP /* %object-class */,
    { (heapptr_t) &SYM_e_HEAP, { 0 } } /* head */,
    { (heapptr_t) &dylanZempty_list_ROOT, { 0 } } /* tail */,
};
