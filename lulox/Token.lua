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

return Token
