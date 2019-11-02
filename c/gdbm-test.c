/*
#include <stdio.h>
#include <gdbm.h>
#include <sys/stat.h>

GDBM_FILE db;
datum key;
datum value;


int
main ()
{


  db = gdbm_open("/home/mc/tmp/wiliki.dbm", 512, GDBM_READER, S_IRUSR, NULL);
  gdbm_fetch(db, key);
  gdbm_close(db);

  return 0;
}

*/

#include <sys/types.h>
#include <limits.h>
#include <gdbm.h>
#include <fcntl.h>
#include <string.h>
#include <stdio.h>


int
main()
{
    GDBM_FILE db;
    datum key;
    datum value;
    int ret;

    char *pkey = "Book:On Lisp";
    char *pvalue = "value";

    key.dptr = pkey;
    key.dsize = strlen(pkey);
    value.dptr = pvalue;
    value.dsize = strlen(pvalue);

    /* gdbm open and store */
    /*
    db = gdbm_open("./db", 1024,
                GDBM_WRCREAT, 0777, NULL);
    gdbm_store(db, key, value, GDBM_INSERT);
    gdbm_close(db);
    */

    /* gdbm open and fetch */
    db = gdbm_open("/home/mc/tmp/wiliki.dbm", 1024,
                GDBM_READER, 0777, NULL);
    if (gdbm_exists(db, key) != 0) {
        value = gdbm_fetch(db, key);
        printf("key: %s, value: %s\n",
            key.dptr, value.dptr);
        free(value.dptr);/* 必ず解放すること！ */
    } else {
        printf("Not Exists\n");
    }
    gdbm_close(db);

    return 0;
}
