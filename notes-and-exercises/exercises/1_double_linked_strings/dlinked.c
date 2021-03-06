/* DLINKED_C */
#include "dlinked.h"
const size_t size_struct = sizeof(strings);                                                                                   

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
		size_t length = MIN(strlen(s), MAXIMUM_STRING_LENGTH-1);
		char *new_string = (char *) ecmalloc(sizeof(char)*(length+1));
		memcpy(new_string, s, length);
		new_string[length] = 0;
		return new_string;
}

strings *set(strings *node, const char *s) 
{
		strings *new_node;

		if ( node == NULL ) return populate(s);
		else
		{
				new_node = node;
				free(new_node->string);
				new_node->string = populate_string(s);
				new_node->length = strlen(new_node->string);
				return new_node;		
		}
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
		for ( unsigned i = 0; node != NULL && i < n; node = node->next, i++ );

		if ( node == NULL ) return append(head, s);

		strings *new_node = populate(s);
		node->prev->next = new_node;		// [0] -> [1]			
		new_node->next = node;			// [1] -> [2]
		new_node->prev = node->prev;		// [0] <- [1]
		node->prev = new_node;			// [1] <- [2]
		node = new_node;
		
		for (; node->prev != NULL; node = node->prev);
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

		// Free the string.
		free(node->string);
		// Move the node links if they exist.
		if ( node->prev != NULL && node->next != NULL ) 
		{
			// [0] -> [2]
			node->prev->next = node->next;
			// [0] <- [2]
			node->next->prev = node->prev;	
		} else
		{ 
			// Move the links for one-sided nodes.
			if ( node->prev != NULL ) node->prev->next = NULL;
			if ( node->next != NULL ) node->next = NULL;
		}	
		
		strings *cached_node = node;
		node = node->next;
		free(cached_node);

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

strings *get_index(strings *head, unsigned n)
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

void teardown(strings **head)
{
	strings *node = *head;
	strings *cached;

	do 
	{
		node->prev = NULL;
		// Free string.
		free(node->string);
		// Cache and move.
		cached = node;
		node = node->next;
		// Remove links.
		cached->next = cached->prev = NULL;
		// Free the cached (previous) node.
		free(cached);
	}	while(node != NULL);
	
	*head = NULL;
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
