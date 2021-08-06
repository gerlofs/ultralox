1. Ponylang uses LLVM.
		(https://github.com/ponylang/ponyc/blob/main/CMakeLists.txt)
		(https://github.com/ponylang/ponyc/tree/main/lib/llvm)
   Imba uses a port of Bison in JS (Jison):
		(https://github.com/zaach/jison).
		(https://github.com/imba/imba/blob/master/src/compiler/compilation.imba).
		(https://github.com/imba/imba/blob/master/src/compiler/grammar.imba1).
		(https://github.com/imba/imba/blob/master/src/compiler/helpers.imba1).
		(https://github.com/imba/imba/blob/master/src/compiler/compiler.imba1).
   SuperCollider uses Bison parser, a hand-rolled lexer:
		(https://github.com/supercollider/supercollider/blob/18c4aad363c49f29e866f884f5ac5bd35969d828/lang/LangSource/PyrLexer.cpp).
		(https://github.com/supercollider/supercollider/blob/18c4aad363c49f29e866f884f5ac5bd35969d828/lang/LangSource/PyrSymbolTable.cpp).

2. Dynamically typed languages such as Python and LISP benefit from fast execution of small scripts. JIT compilation increases the initial overhead for runtime efficiency - this doesn't make much sense for small, short-lived programs - HotSpot JVM has *client* mode to reduce this start-up lag. Some high-level languages are built on libraries written in compiled languages, JIT compilation doesn't improve the performance of already compiled libraries. 

3. As per the above, intepreters are useful for shorter snippets of code - writing and executing code which can then be compiled once a final version is arrived at. This process is quicker when writing and debugging code that isn't going to be built as a release. 
