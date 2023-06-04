module TestPrograms
using Test
using Brainfuck

ops = read("test/programs/hello2.bfk", String) |> Brainfuck.lexandparse
io = IOBuffer()
Brainfuck.interpret(ops, io_out = io)
@test String(take!(io)) == "Hello world!\n"

text = read("test/programs/99bottles.bfk", String)
io = IOBuffer()
Brainfuck.brainfuck(text, io_out = io)
end
