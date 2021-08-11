local exit_codes = require "exit_codes"
local Lexer = require "lexer"

Lox = {
	error_occurred = false
}

function Lox:reportError(line, message)
	io.write("[" .. tostring(line) .. "]: " .. message .. "\10\13")
	self.error_occurred = true
end

function Lox:run(source)
	-- TODO: Add error checking.
	local tokens = Lox.Scanner:scanTokens(source)
	for _, t in pairs(tokens) do
		print("TOKEN: " .. t:toString())
	end
end

function Lox:runPrompt()
	while true do
		io.write(">")
		local line = io.read()
		if ( line == nil ) then break end
		Lox:run(line)
	end
end

function Lox:runFile(filename)
	if ( Lox.error_occurred ) then
		os.exit(exit_codes.EX_DATAERR)
	end
	
	local file_handler = Lox.Scanner:openFile(filename)
	local lines = Lox.Scanner:readWholeFile(file_handler)
	Lox:run(lines)
end

function Lox:init()
	Lox.Scanner = Scanner

	local argc = #arg
	if ( argc > 1 ) then 
		io.write("Usage: lulox [script]", "\10\13");
		os.exit(exit_codes.EX_USAGE);
	elseif ( argc == 1 ) then
		-- Run the input file.
		Lox:runFile(arg[1])
	else
		-- Run the stdin interpreter.
		Lox:runPrompt()
	end
end

Lox:init()
