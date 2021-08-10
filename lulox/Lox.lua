local exit_codes = require "exit_codes"

Lox = {
	error_occurred = false
}

function Lox:reportError(line, message)
	io.write("[" .. tostring(line) .. "]: " .. message .. "\10\13")
	self.error_occurred = true
end

function Lox:run(source)
	io.write(source, "\10\13")
end

function Lox:runPrompt()
	while true do
		io.write(">")
		local line = io.read()
		if ( line == nil ) then break end
		self:run(line)
	end
end

function Lox:runFile()
	if ( self.error_occurred ) then
		os.exit(exit_codes.EX_DATAERR)
	end
end

function Lox:init()
	local argc = #arg
	if ( argc > 1 ) then 
		io.write("Usage: lulox [script]", "\10\13");
		os.exit(exit_codes.EX_USAGE);
	elseif ( argc == 1 ) then
		-- Run the input file.
		
	else
		-- Run the stdin interpreter.
		self:runPrompt()
	end
end

return Lox
