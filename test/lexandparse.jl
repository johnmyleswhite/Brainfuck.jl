module TestLexAndParse
    using Base.Test
    using Brainfuck

    s1 = "<-->"

    @test Brainfuck.lexandparse(s1) == [
        Brainfuck.OP2,
        Brainfuck.OP4,
        Brainfuck.OP4,
        Brainfuck.OP1,
    ]

    s2 = """
        >--< ++ -- ><
        >--< ++ -- ><
    """

    @test Brainfuck.lexandparse(s2) == [
        Brainfuck.OP1,
        Brainfuck.OP4,
        Brainfuck.OP4,
        Brainfuck.OP2,
        Brainfuck.OP3,
        Brainfuck.OP3,
        Brainfuck.OP4,
        Brainfuck.OP4,
        Brainfuck.OP1,
        Brainfuck.OP2,

        Brainfuck.OP1,
        Brainfuck.OP4,
        Brainfuck.OP4,
        Brainfuck.OP2,
        Brainfuck.OP3,
        Brainfuck.OP3,
        Brainfuck.OP4,
        Brainfuck.OP4,
        Brainfuck.OP1,
        Brainfuck.OP2,
    ]
end
