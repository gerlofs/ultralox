local Token = require "Token"

-- Useful string helpers. Might move out soon idk.
function splitString(string, delimiter)
	local strings = {}
	local altered_string = string
	for matching in string:gmatch("(%w+)"..delimiter) do
		table.insert(strings, matching)
		altered_string = altered_string:gsub(matching..delimiter,
								"")
	end
	table.insert(strings,altered_string)
	return strings
end

function parenthesise(name, expressions)
	local string = "(" .. name
	for key, expr in pairs(expressions) do
		string = string .. " " .. expr:accept()
	end
	string = string .. ")"
	return string
end

-- Base Visitor class
Visitor = {}
function Visitor:init(object)
	object = object or {}
	setmetatable(object, self)
	self.__index = self
	return object
end

function Visitor:visitBinaryExpr(expr)
	print("Visited binary expression! ")
	return parenthesise(expr.operator.lexeme,
				{expr.left, expr.right})
end

function Visitor:visitLiteralExpr(expr)
	print("Visited literal expression!")
	if ( expr.value == nil ) then return "nil" end
	return tostring(expr.value)
end
-- Base Expr class
Expr = {}
function Expr:init(object) 
	object = object or {}
	setmetatable(object, self)
	self.__index = self
	return object
end

-- For each class, extend the expr class.
Binary = Expr:init()
Grouping = Expr:init()
Literal = Expr:init()
Unary = Expr:init()

-- Takes two expressions and a token.
function Binary:accept()
	return Visitor:visitBinaryExpr(self)
end

-- Takes an expression
function Grouping:init(expression)
	self.expression = expression
end

-- Takes an object
function Literal:accept()
	return Visitor:visitLiteralExpr(self)
end

-- Takes a token and an expression
function Unary:init(operator, right)
	self.operator = operator
	self.right = right
end

l = Literal:init{value=10}
r = Literal:init{value=5}
b = Binary:init{left=l, 
		operator=Token:init({
		typestring="ADD", lexeme="+", 
		literal=nil, line=33}), 
		right=r}
print(b:accept())
--[[
nd

Tree = {}

function Tree:setOutputDirectory()
	if ( #arg ~= 1 ) then
		io.stderr.write("Usage: generate_ast <output directory>")
		io.exit(64)
	end
	Tree.outputDirectory = arg[1]
end

function Tree:defineType(fh, base_name, class_name, fields)
	
end

function Tree:defineAST(base_name, types)
	local write_directory = Tree.outputDirectory .. "/" .. 
				base_name .. ".lua"
	local write_fh = assert(io.open(write_directory, "w"))
	-- Create the base class (table).
	write_fh.write(base_name .. "={}")
	for _, t in pairs(types) do
		local temp = splitString(t, ": ")
		local class_name = temp[1]
		local fields = temp[2]
		Tree:defineType(write_fh, base_name, class_name, fields)
	end
	write_fh:close()
end

function Tree:generateAST()
	Tree:setOutputDirectory()
	local types = {
		"Binary : Expr left, Token operator, Expr right",
		"Grouping : Expr expression",
		"Literal : Object value",
		"Unary : Token operator, Expr right"
	}
	Tree:defineAST("Expr", types)
end--]]
