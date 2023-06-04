module TestInterpreter

using Test
using Brainfuck

struct MyIO <: IO
    bytes::Vector{UInt8}
end
Base.write(io::MyIO, val::UInt8) = push!(io.bytes, val)
Base.read(io::MyIO, ::Type{UInt8}) = popfirst!(io.bytes)

text = read("test/programs/print.bfk", String)
ops = Brainfuck.lexandparse(text)

io1 = MyIO(UInt8[])
write(io1, 'a')
write(io1, 'b')
io2 = IOBuffer()
Brainfuck.interpret(ops, io_in = io1, io_out = io2)
@test take!(io2) == [0x62, 0x61, 0x63, 0x62]


io1 = MyIO(UInt8[])
write(io1, 'a')
write(io1, 'b')
io2 = IOBuffer()
Brainfuck.brainfuck(text, io_in = io1, io_out = io2)
@test take!(io2) == [0x62, 0x61, 0x63, 0x62]

end
