#include "dlinked.h"

void assert(int, const char*);

void assert(int condition, const char *s)
{
	// Wrapper for checking boolean outcomes.
	// Provide both the condition to check and a string copy, e.g.
	// 		assert(meaning() == 42, "function 'meaning' returns 42");
	if (!condition)
	{
		fprintf(stderr, "Condition [%s] was false, exiting\n", s);
		exit(1);
	}

	fprintf(stdout, "%s [SUCCESS]\n", s);
}

int main(void)
{
	// 1. Create an new linked list.
	fprintf(stdout, "1: Creating a new linked list...\n");
	strings *head = set(NULL, "First");
	assert(head != NULL, "Head is not null");
	assert(head->string != NULL, "Head string exists");
	assert(head->length != 0, "Head string has a length");
	assert(head->next == NULL && head->prev == NULL, "Head is solo");
	// 2. Adding a new node to the existing linked list.
	fprintf(stdout, "2: Adding a node...\n");
	strings *stored_head = head;
	head = append(head, "Second");
	strings *appended = head->next;
	assert(head == stored_head, "Head is returned");
	assert(appended != NULL, "Appended node exists");
	assert(appended->string != NULL, "Appended string exists");
	assert(appended->length != 0, "Appended string has length");
	assert(appended->next == NULL && appended->prev == head, "Check appended node position");
	// 3. Change string of an existing node.
	fprintf(stdout, "3: Change string of existing node... \n");
	strings *changed = set(appended, "Third");
	assert(changed != NULL, "Changed node still exists");
	assert(changed->string != NULL, "String still exists");
	assert(memcmp(changed->string, "Third", 6) == 0, "String is correct");
	assert(changed->length == strlen("Third"), "Length is correct");
	assert(changed->prev == head && changed->next == NULL, "Position is correct");	
	// 4. Insert a new string between the head and existing node.
	fprintf(stdout, "4: Insert a new node...\n");
	head = insert(head, "Second", 1);	
	print(head);
	strings *inserted = head->next;
	assert(inserted != NULL, "Inserted node exists");
	assert(inserted->string != NULL && inserted->length != 0, "Inserted string exists");
	assert(inserted->prev == head && inserted->next != NULL, "Inserted position is correct");	
	assert(memcmp(inserted->string, "Second", 7) == 0, "Inserted string is correct"); 
	// 5. Append an overly long string, ensure its truncated.
	fprintf(stdout, "5: Append an overly long string...\n");
	head = append(head, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.");
	appended = appended->next;
	assert(appended != NULL && appended->next == NULL, "Appended node exists and position is correct");
	assert(appended->string != NULL && appended->length == MAXIMUM_STRING_LENGTH-1, "Appended string is correct");
	// 6. Lookup a string in the list by index.
	fprintf(stdout, "6: Index a node in the list...\n");
	strings *indexed = get_index(head, 3);
	assert(indexed != NULL && indexed == appended, "Appended node found");
	assert(indexed->prev->prev->prev == head, "Appended node position is correct");
	// TODO: Add integrity test to check nothing was altered? Necessary?
	// 7. Remove a node.
	fprintf(stdout, "7: Remove a node... \n");
	head = destroy(head->next);
	strings *node = get_index(head, 1);
	assert(head->next->next->next == NULL, "One less item in the list");
	assert(node->length == head->next->length, "Item is correct");
	assert(node->prev == head, "Item position is correct");
	// 8. Find a node by its string.
	fprintf(stdout, "8: Find a string in the list... \n");
	strings *found = find(head, "Third");
	assert(found != NULL && found->prev == head, "Found item exists and is correct");
	assert(found->next != NULL, "Found item has correct position");
	// 9. Fail to find.
	fprintf(stdout, "9: Fail to find a string... \n");
	found = find(head, "Jibberish");
	assert(found == NULL, "Null returned");
	// 10. Kill the tree.
	fprintf(stdout, "10: Teardown the tree... \n");
	teardown(&head);
	assert(head == NULL, "Tree teardown successful");
	return 1;
}
