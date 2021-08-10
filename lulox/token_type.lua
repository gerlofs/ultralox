--[[
--	Convert a regular table into an enum to be used to contain
--		the types of tokens available.
--	Borrowed from Alex Silva's blog post: 
--	http://www.unendli.ch/posts/2016-07-22-enumerations-in-lua.html
--]]

tokens =  {
		-- Single-character tokens.
		"LEFT_PAREN", "RIGHT_PAREN", "LEFT_BRACE", "RIGHT_BRACE",
		"COMMA", "DOT", "MINUS", "PLUS", "SEMICOLON", "SLASH", 
		"STAR",
		-- One-or-two character tokens.
		"BANG", "BANG_EQUAL", "EQUAL", "EQUAL_EQUAL", "GREATER",
		"GREATER_EQUAL", "LESS", "LESS_EQUAL",
		-- Literals
		"IDENTIFIER", "STRING", "NUMBER",
		-- Keywords
		"AND","CLASS","ELSE","FALSE","FUN","FOR","IF","NIL","OR",
		"PRINT","RETURN","SUPER","THIS","TRUE","VAR","WHILE","EOF"
}

function create_enum(t)
	new_t = {}
	local l = #t
	for i = 1, l do
		local k = t[i]
		new_t[k] = i
	end

	return new_t
end

local new_tokens = create_enum(tokens)

return new_tokens
