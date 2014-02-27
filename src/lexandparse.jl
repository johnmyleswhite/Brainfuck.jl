# Basic operations
const OP1 = 1 # >
const OP2 = 2 # <
const OP3 = 3 # +
const OP4 = 4 # -
const OP5 = 5 # ,
const OP6 = 6 # .
const OP7 = 7 # [
const OP8 = 8 # ]

function char2op(chr::Char)
    const chars2ops = Dict(['>', '<', '+', '-', ',', '.', '[', ']'], 1:8)
    return chars2ops[chr]
end

function lexandparse(s::String)
    ops = Array(Int, 0)

    i = nextind(s, 0)

    line, character = 1, 0

    while i <= endof(s)
        chr = s[i]
        character += 1

        while isspace(chr)
            if chr == '\n'
                line += 1
                character = 0
            end
            i = nextind(s, i)
            if i <= endof(s)
                chr = s[i]
                character += 1
            else
                return ops
            end
        end

        if !(chr in ['>', '<', '+', '-', ',', '.', '[', ']'])
            msg = @sprintf(
                "Invalid token found at line %d, character %d",
                line,
                character
            )
            throw(ArgumentError(msg))
        else
            push!(ops, char2op(chr))
        end

        i = nextind(s, i)
    end

    return ops
end
