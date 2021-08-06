```
gcc -g -Wall dlinked.c tests.c -o tests
valgrind --leak-check=full ./tests 
```
