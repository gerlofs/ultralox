1. A class (function to initalise plus methods and attributes): 
```
	expr -> expr "(" expr "," ... "," expr "," expr ")"
	expr -> expr "(" expr ")"
	expr -> expr "(" ")"
	expr -> expr "." IDENTIFIER
	expr -> expr "." IDENTIFIER "." IDENTIFIER
	expr -> IDENTIFIER
	expr -> NUMBER
```
2. TODO

3. [See: ast.lua, run with Polish (not-so) secret phrase](../../lulox/ast.lua)
