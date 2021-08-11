1. Haskell has the interesting point of being able to denote an infinite list of something and only evaluate as many things as it needs. 

Python has idents which dictate blocks and, therefore, scoping of variables.

2. The C pre-processor makes use of spaces to seperate definitions from their defined values - e.g. `#DEFINE VARIABLE VALUE`

3. As in the above example, spaces are required to be lexed along with pre-requisite characters for multiple-character-lexemes. 

Golfing languages? 

4. See [here](../../lulox/lexer.lua). 

Thankfully `Scanner:advance()` handles newlines. 

Nesting implemented by passing the number of remaining comment lexemes to find, if we hit the end of the source file without finding the same number of closing blocks as were opened, we throw an "unterminated comment block" error. This is slightly more work but nothing too hard.
