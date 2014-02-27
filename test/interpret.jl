module TestInterpreter
    using Base.Test
    using Brainfuck

    type MyIO <: IO
        bytes::Vector{Uint8}
    end
    Base.write(io::MyIO, val::Uint8) = push!(io.bytes, val)
    Base.read(io::MyIO, ::Type{Uint8}) = shift!(io.bytes)

    text = readall(Pkg.dir("Brainfuck", "test", "programs", "print.bfk"))
    ops = Brainfuck.lexandparse(text)

    io1 = MyIO(Uint8[])
    write(io1, 'a')
    write(io1, 'b')
    io2 = IOBuffer()
    Brainfuck.interpret(ops, io_in = io1, io_out = io2)
    @test takebuf_array(io2) == [0x62, 0x61, 0x63, 0x62]

    io1 = MyIO(Uint8[])
    write(io1, 'a')
    write(io1, 'b')
    io2 = IOBuffer()
    Brainfuck.brainfuck(text, io_in = io1, io_out = io2)
    @test takebuf_array(io2) == [0x62, 0x61, 0x63, 0x62]
end
