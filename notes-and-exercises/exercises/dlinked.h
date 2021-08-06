/* DLINKED_H */

#ifndef DLINKED_H
#define DLINKED_H
#include <stdio.h>	// stdin/stdout helpers.
#include <stdlib.h> // Malloc.
#include <errno.h> 	// Errors.
#include <string.h> // strlen and memcpy.

typedef struct dlstrings {
		char *string;
		size_t length;
		struct dlstrings *next;
		struct dlstrings *prev;
} strings;

const size_t size_struct = sizeof(strings);
void *ecmalloc(size_t);
void *ecrealloc(void*, size_t);
char *populate_string(const char*);

strings *populate(const char*);
strings *set(strings*, const char*);
strings *insert(strings *, const char*, unsigned);
strings *destroy(strings *);
strings *index(strings*, unsigned);
strings *find(strings*, const char*);
void teardown(strings*);
void print(strings*);

#endif
