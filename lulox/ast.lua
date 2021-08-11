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

function rpn_parenthesise(name, expressions)
	local string = "("
	for key, expr in pairs(expressions) do
		string = string .. " " .. expr:accept()
	end
	string = string .. " " .. name .. " )"
	return string
end
function parenthesise(name, expressions)
	local string = "(" .. name
	for key, expr in pairs(expressions) do
		string = string .. " " .. expr:accept()
	end
	string = string .. ")"
	return string
end


if ( #arg > 0 ) and ( arg[1] == "Łukasiewicz" ) then
	print("Wejście w tryb polski!")
	parenthesise = rpn_parenthesise
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
	return parenthesise(expr.operator.lexeme,
				{expr.left, expr.right})
end

function Visitor:visitLiteralExpr(expr)
	if ( expr.value == nil ) then return "nil" end
	return tostring(expr.value)
end

function Visitor:visitGroupingExpr(expr)
	return parenthesise("group", {expr.expression})
end

function Visitor:visitUnaryExpr(expr)
	return parenthesise(expr.operator.lexeme, {expr.right})
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

-- Takes an object
function Literal:accept()
	return Visitor:visitLiteralExpr(self)
end

function Grouping:accept()
	return Visitor:visitGroupingExpr(self)
end

function Unary:accept()
	return Visitor:visitUnaryExpr(self)
end

binary_expr = Binary:init{
	left=Binary:init{
		left=Literal:init{value=1},
		operator=Token:init({
			typestring="PLUS",
			lexeme="+",
			literal=nil,
			line=1
		}),
		right=Literal:init{value=2}
	},
	operator=Token:init({
		typestring="STAR",
		lexeme="*",
		literal=nil,
		line=1
	}),
	right=Binary:init{
		left=Literal:init{value=4},
		operator=({
			typestring="MINUS",
			lexeme="-",
			literal=nil,
			line=1
		}),
		right=Literal:init{value=3},
	}
}
print(binary_expr:accept())

binary_expr = Binary:init{
	left=Literal:init{value=10},
	operator=Token:init({
			typestring = "PLUS",
			lexeme = "+",
			literal = nil,
			line = 1}),
	right=Literal:init{value = 5}}
print(binary_expr:accept())
