local exit_codes = require "exit_codes"
local token_type = require "token_type"

Token = {}
Token.__index = Token

function Token:init(settings)
	local token = {}
	setmetatable(token,Token)
	token.typestring = settings.typestring
	token.lexeme = settings.lexeme
	token.literal = settings.literal
	token.line = settings.line
	return token
end

function Token:toString()
	return "" .. tostring(self.typestring) .. 
		" " .. tostring(self.lexeme) ..
		" " .. tostring(self.literal) ..
		" " .. tostring(self.line)
end

Scanner = {
	reserved = {"AND", "CLASS", "ELSE", "FALSE", "FOR", "FUN",
			"IF", "NIL", "OR", "PRINT", "RETURN", "SUPER", 
			"THIS", "TRUE", "VAR", "WHILE"}
}

function Scanner:init(filename) 
	-- TODO: Create actual class using metatables.
	-- Scanner.fh = self:openFile(filename)
end

function Scanner:openFile(filename)
	local fh = assert(io.open(filename, "r"))
	return fh
end

function Scanner:readWholeFile(fh)
	if ( fh == nil ) then
		io.stderr:write("Cannot parse file handler!")
		io.exit(exit_codes.EX_NOINPUT)
	end
	local lines = fh:read("*all")
	if ( lines == nil ) then exit(1) end
	return lines
end

function Scanner:atEnd()
	return Scanner.current >= Scanner.source:len()
end

function Scanner:scanTokens(source)
	Scanner.tokens = {}
	Scanner.start, Scanner.current, Scanner.line = 1, 1, 1
	Scanner.source = source	
	while not (Scanner:atEnd()) do
		Scanner.start = Scanner.current
		self:findToken()
	end

	Scanner:addToken("EOF", nil)

	return Scanner.tokens
end

function Scanner:advance()
	local char = Scanner.source:sub(Scanner.current, Scanner.current)
	Scanner.current = Scanner.current + 1
	if ( char == '\n' ) then Scanner.line = Scanner.line + 1 end 
	return char
end

function Scanner:findToken()
	local char = Scanner:advance()
	if ( char == ' ' or char == '\r' or char == '\t' ) then return
	elseif ( char == '(' ) then Scanner:addToken("LEFT_PAREN", nil)
	elseif ( char == ')') then Scanner:addToken("RIGHT_PAREN", nil)
	elseif ( char == '{') then Scanner:addToken("LEFT_BRACE", nil)
	elseif ( char == '}') then Scanner:addToken("RIGHT_BRACE", nil)
	elseif ( char == ',') then Scanner:addToken("COMMA", nil)
	elseif ( char == '.') then Scanner:addToken("DOT", nil)
	elseif ( char == '-') then Scanner:addToken("MINUS", nil)
	elseif ( char == '+') then Scanner:addToken("PLUS", nil)
	elseif ( char == ';') then Scanner:addToken("SEMICOLON", nil)
	elseif ( char == '*') then Scanner:addToken("STAR", nil)
	elseif ( char == '!') then Scanner:addToken(
		(Scanner:matchNext('=') and "BANG_EQUAL" or "BANG"))
	elseif ( char == '=') then Scanner:addToken(
		(Scanner:matchNext('=') and "EQUAL_EQUAL" or "EQUAL"))
	elseif ( char == '<') then Scanner:addToken(
		(Scanner:matchNext('=') and "LESS_EQUAL" or "LESS"))
	elseif ( char == '>') then Scanner:addToken(
		(Scanner:matchNext('=') and "GREATER_EQUAL" or "GREATER"))
	elseif ( char == '/' ) then
		if ( Scanner:matchNext('/') ) then
			while ( Scanner:peekAhead() ~= '\n'
				and (not Scanner:atEnd()) ) do
				Scanner:advance()
			end
		else
			Scanner:addToken("SLASH");
		end
	elseif ( char == '"' ) then
		Scanner:string()
	elseif ( Scanner:isDigit(char) ) then
		Scanner:number()
	elseif ( Scanner:isAlpha(char) ) then
		Scanner:identifier()
	else Lox:reportError(Scanner.line, "Unexpected character")
	end
end

function Scanner:matchNext(expected_char)
	if ( Scanner:atEnd() ) then return false end
	local char = Scanner.source:sub(Scanner.current, Scanner.current)
	if ( char ~= expected_char ) then return false end
	Scanner.current = Scanner.current + 1
	return true
end

function Scanner:peekAhead()
	if ( Scanner:atEnd() ) then return '\0' end
	return Scanner.source:sub(Scanner.current, Scanner.current)
end

function Scanner:doublePeek()
	local ahead_pos = Scanner.current + 1
	if ( (ahead_pos) >= Scanner.source:len() ) then
		return '\0' 
	end
	return Scanner.source:sub(ahead_pos, ahead_pos)
end

function Scanner:addToken(typestring, literal)
	--[[
	--	Create a new token instance containing the lexeme 
	--		(actual text), its type (lookup token_type 
	--		table), its line in the source text, and 
	--		its literal value if required.
	--	Insert the token into the class-wide table.
	--]]
	text = Scanner.source:sub(Scanner.start, Scanner.current)
	local new_token = Token:init({typestring=token_type[typestring],
		lexeme=text,
		literal=literal, 
		line=Scanner.line})
	table.insert(Scanner.tokens, new_token)	
end

function Scanner:contains(table, match)
	for key, value in pairs(table) do
		if ( key == match ) or ( value == match ) then
			return key
		end
	end
	return nil
end

function Scanner:identifier()
	while ( Scanner:isAlphaNum(Scanner:peekAhead()) ) do
		Scanner:advance()
	end
	local string = Scanner.source:sub(
			Scanner.start, Scanner.current-1):upper()
	local result = Scanner:contains(Scanner.reserved, string)

	if ( result ) then
		Scanner:addToken(result) 
	else
		Scanner:addToken("IDENTIFIER")
	end
end

function Scanner:isAlpha(char)
	-- Of course I am...
	return ((char >= 'a' and char <= 'z') or
		(char >= 'A' and char <= 'Z') or
		(char == '_'))
end

function Scanner:isAlphaNum(char)
	return Scanner:isAlpha(char) or Scanner:isDigit(char)
end

function Scanner:string()
	while ( Scanner:peekAhead() ~= '"' and (not Scanner:atEnd()) ) do
		Scanner:advance()
	end
	if ( Scanner:atEnd() ) then 
		Lox:reportError(Scanner.line, "Unterminated String!")
		return
	end
		
	Scanner:addToken("STRING", Scanner.source:sub(Scanner.start+1,
		Scanner.current-1))
	Scanner:advance() -- consume end quote.
end

function Scanner:number()
	while ( Scanner:isDigit(Scanner:peekAhead()) ) do	
		Scanner:advance()
	end
	
	if ( Scanner:peekAhead() == '.' and 
		Scanner:isDigit(Scanner:doublePeek()) ) then
		Scanner:advance() -- Consume the dot so it is not parsed
		while ( Scanner:isDigit(Scanner:peekAhead()) ) do
			Scanner:advance()
		end
	end

	Scanner:addToken("NUMBER", tonumber(Scanner.source:sub(
		Scanner.start, Scanner.current)))
end

function Scanner:isDigit(char)
	return char >= '0' and char <= '9'
end

--Scanner:init()
--Scanner.fh = Scanner:openFile("test.lox")
--local lines = Scanner:readWholeFile(Scanner.fh)
--local tokens = Scanner:scanTokens(lines)
return { Scanner, Token }
