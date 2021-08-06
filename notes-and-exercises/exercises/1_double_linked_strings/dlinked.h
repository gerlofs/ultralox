/* DLINKED_H */

#ifndef DLINKED_H
#define DLINKED_H

#define MIN(x, y) (((x) < (y)) ? (x) : (y))
#define MAXIMUM_STRING_LENGTH 1024
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

void *ecmalloc(size_t);
void *ecrealloc(void*, size_t);
char *populate_string(const char*);

strings *populate(const char*);
strings *set(strings*, const char*);
strings *append(strings*, const char*);
strings *insert(strings *, const char*, unsigned);
strings *destroy(strings *);
strings *get_index(strings*, unsigned);
strings *find(strings*, const char*);
void teardown(strings**);
void print(strings*);

#endif
