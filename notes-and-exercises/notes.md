### Single-pass:
- Compilers that interleave parsing, analysis, and generation without using ASTs. Lacking structures means that lines are evaulated as-is when they appear. This is the reason why you need function declarations (prototypes) in C and why Pascal requires type declaration at the start of a block.

### Tree-walk:
- ASTs are traversed and evaulated node-by-node. This is how small intepreters work, they are often slower though. Early versions of Ruby were tree-walk interpreters.

### Transpiler:
- Use a hand-rolled front end for your flashy new language to convert it into an existing language with existing tools, then compile the intermediate language (e.g. C) using those existing tools.

### JIT:
- Compile during the program load time. 
- Hook into code, profile during runtime and recompile hotspots and performance-critical areas with further optimizations. Only really cool, complex JIT compilers do this.

### Compilers vs. Intepreters:
- A compiler translates a source language into another, without executing it.
- An interpreter executes a program from source.
- Most scripting languages have an intepreter and a compiler, e.g. compilation to bytecode which is run. 

### Static vs. dynamic typing:
- Dynamic typing allows for polymorphism and containment of multiple types into a single variable (e.g. tuples in Python, lists in Lua), It is also easier to implement dynamic typing by defering type checking to the run time environment (the intepreter). 

### Memory management / garbage collection:
- We will come back to this: basically you can reference count or garbage collect. However, these behave (similarly)[https://researcher.watson.ibm.com/researcher/files/us-bacon/Bacon04Unified.pdf]

### Closures:
- Functions with scoped variables that matter enough that they need to be kept around even when an outer function is long gone.

```
fun outer() {
		var outside = "Hills";

		fun inner() {
				print outside;
		}

		return inner;
}

var fn = outer();
fn(); // Prints "Hills".
```
Read (this)[https://homepages.inf.ed.ac.uk/wadler/papers/papers-we-love/landin-next-700.pdf].

### Misc:
- Lox has no bitwise shift, modulo, conditional operators. Implement them?
