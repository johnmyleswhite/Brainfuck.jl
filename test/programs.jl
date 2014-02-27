module TestPrograms
    using Base.Test
    using Brainfuck

    text = readall(Pkg.dir("Brainfuck", "test", "programs", "hello2.bfk"))
    ops = Brainfuck.lexandparse(text)
    io = IOBuffer()
    Brainfuck.interpret(ops, io_out = io)
    @test takebuf_string(io) == "Hello world!\n"

    text = readall(Pkg.dir("Brainfuck", "test", "programs", "99bottles.bfk"))
    io = IOBuffer()
    Brainfuck.brainfuck(text, io_out = io)
end
