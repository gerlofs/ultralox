/* DLINKED_C */
#include "dlinked.h"

void *ecmalloc(size_t nbytes)
{
		void *ptr = malloc(nbytes);
		if ( ptr == NULL ) 
		{
				perror("Unable to allocate...");
				exit(errno);
		}
		return ptr;
}

void *ecrealloc(void *oldptr, size_t nbytes)
{
		void *newptr = realloc(oldptr, nbytes);
		if ( newptr == NULL ) 
		{
				perror("Unable to reallocate");
				free(oldptr);
				exit(errno);
		}
		return newptr;
}

char *populate_string(const char *s)
{
		size_t length = strlen(s);
		char *new_string = (char *) ecmalloc(sizeof(char)*(length+1));
		memcpy(new_string, s, length);
		new_string[length] = 0;
		return new_string;
}

strings *set(strings *node, const char *s) 
{
		strings *new_node;

		if ( node == NULL ) 
		{
				new_node = (strings *) ecmalloc(sizeof(strings));
				new_node->next = NULL;
		} else
		{
				new_node = node;
		}

		return populate(s);	
}

strings *append(strings *head, const char *s)
{	// Append an item to the end of the list then return the head.
		// Find the last node (not a leaf).
		strings *node;
		for ( node = head; node->next != NULL; node = node->next );
		
		// Create new node, populate, then stick on the end.
		strings *new_node = populate(s);
		new_node->prev = node;
		new_node->next = NULL;
		node->next = new_node;

		for ( ; node->prev != NULL; node = node->prev );
		return node; // Return head.
}

strings *insert(strings *head, const char *s, unsigned n)
{	// Create new node, insert into existing list.
		// If the input index exceeds the total length of the list,
		// 		append instead...
		strings *node = head;
		for ( unsigned i = 0; node != NULL && i < n; 
								node = node->next, i++ );
		if ( node == NULL ) return append(head, s);

		strings *new_node = populate(s);
		new_node->next = node;
		new_node->prev = node->prev;
		node->prev = new_node;

		for ( ; node->prev != NULL; node = node->prev );
		return node; // Return new head.
}

strings *destroy(strings *node)
{
		// TODO: Add handling for NULL input.
		if ( node == NULL ) 
		{
				fprintf(stderr, "Cannot handle null input to destroy");
				exit(1);
		}

		free(node->string);
		free(node);

		if ( node->next != NULL ) 
		{
				if ( node->prev != NULL ) 
				{
						node->prev->next = node->next;
						node->next->prev = node->prev;
				} else
				{
						node->next->prev = NULL;
						return node->next;
				}
		} else {
				if ( node->prev != NULL ) 
				{
						node->prev->next = NULL;
				}
		}

		for ( ; node->prev != NULL; node = node->prev);
		return node;
}

strings *find(strings *head, const char *s)
{	// Iterate through linked list mem. comparing until we find
		// a match, return the match or (can't find) return NULL.
		strings *node;
		for ( node = head; node != NULL; node = node->next ) 
		{
				if ( memcmp(s, node->string, node->length) == 0 )
				{
						return node;
				}
		}
		
		return NULL;
}

strings *index(strings *head, unsigned n)
{
		strings *node;
		unsigned i = 0;
		for ( node = head; node->next != NULL && i < n; 
				node = node->next, i++);
		return node;
}

strings *populate(const char *s)
{
		strings *node = (strings *) ecmalloc(size_struct);
		node->string = populate_string(s);
		node->length = strlen(node->string);
		node->next = NULL;
		node->prev = NULL;
		return node;
}

void teardown(strings *head)
{
		strings *node;
		if ( head->next == NULL ) 
		{
				if ( head->string != NULL ) free(head->string);
				free(head);
				return;
		}

		node = head->next;
		do {
				if ( node->prev->string != NULL ) free(node->prev->string);
				free(node->prev);
				node = node->next;
		} while (node != NULL && node->next != NULL);
}

void print(strings *head)
{
		strings *node;
		for ( node=head; node != NULL; node=node->next )
		{
				fprintf(stdout, "[%s]", node->string);
				if ( node->next != NULL ) fprintf(stdout,
						"<->");
		}
		printf("\n");
}

/* MAIN */
int main(void)
{
		// Create a doubly-linked list with heap allocated strings.
		strings *head = set(NULL, "Hello World!");
		head->next = set(NULL, "Wow!");
		head->next->prev = head;
		head = append(head, "No way!");
		head = insert(head, "!dlroW olleH", 0);
		print(head);
		strings *node = index(head, 1);
		print(node);
		node = find(head, "Wow!");
		print(node);
		head = destroy(node);
		print(head);
		// Write function to free internals.
		teardown(head);
		return 0;
}
