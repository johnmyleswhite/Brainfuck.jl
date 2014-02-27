function opstring(op::Integer)
    strings = [
        ">",
        "<",
        "+",
        "-",
        ".",
        ",",
        "[",
        "]",
    ]
    return strings[op]
end

function printbeforeop(
    op::Integer,
    memory::Vector{Uint8},
    memory_pointer::Integer,
)
    @printf(
        STDERR,
        "\n---\nBefore executing '%s': (%s, %d)\n",
        opstring(op),
        repr(memory),
        memory_pointer
    )
    return
end

function printafterop(
    op::Integer,
    memory::Vector{Uint8},
    memory_pointer::Integer,
)
    @printf(
        STDERR,
        "After executing '%s': (%s, %d)\n---\n\n",
        opstring(op),
        repr(memory),
        memory_pointer
    )
    return
end

function interpret(
    ops::Vector{Int};
    debug::Bool = false,
    io_in::IO = STDIN,
    io_out::IO = STDOUT
)
    memory_pointer = 1
    memory = zeros(Uint8, 1)
    opindex = 1

    n_ops = length(ops)

    while opindex <= n_ops
        op = ops[opindex]

        if debug
            printbeforeop(op, memory, memory_pointer)
        end

        # OP1: >
        #
        # Move the Memory Pointer to the next array cell.
        #
        if op == OP1
            memory_pointer += 1
            if memory_pointer > length(memory)
                push!(memory, 0x00)
            end
            opindex += 1

        # OP2: <
        #
        # Move the Memory Pointer to the previous array cell.
        #
        elseif op == OP2
            # TODO: Confirm that this is appropriate
            if memory_pointer > 1
                memory_pointer -= 1
            end
            opindex += 1

        # OP3: +
        #
        # Increment the array cell pointed at by the Memory Pointer.
        #
        elseif op == OP3
            memory[memory_pointer] += 1
            opindex += 1

        # OP4: -
        #
        # Decrement the array cell pointed at by the Memory Pointer.
        #
        elseif op == OP4
            memory[memory_pointer] -= 1
            opindex += 1

        # OP5: ,
        #
        # Read a character from STDIN and put its ASCII value into the cell
        # pointed at by the Memory Pointer.
        #
        elseif op == OP5
            memory[memory_pointer] = read(io_in, Uint8)
            opindex += 1

        # OP6: .
        #
        # Print the character with ASCII value equal to the value in the cell
        # pointed at by the Memory Pointer.
        #
        elseif op == OP6
            if debug
                @printf(STDERR, "Printing '%s'\n", char(memory[memory_pointer]))
            end
            print(io_out, char(memory[memory_pointer]))
            opindex += 1

        # OP7: [
        #
        # Move to the command following the matching Ook? Ook! if the value in
        # the cell pointed at by the Memory Pointer is zero. Note that
        # Ook! Ook? and Ook? Ook! commands nest like pairs of parentheses, and
        # matching pairs are defined in the same way as for parentheses.
        #
        elseif op == OP7
            if memory[memory_pointer] == 0x00
                level = 0
                opindex += 1
                complete = false
                while !complete && opindex <= n_ops
                    if ops[opindex] == OP7
                        level += 1
                        opindex += 1
                    elseif ops[opindex] == OP8
                        if level == 0
                            opindex += 1
                            complete = true
                        else
                            level -= 1
                            opindex += 1
                        end
                    else
                        opindex += 1
                    end
                end
            else
                opindex += 1
            end

        # OP8: ]
        #
        # Move to the command following the matching Ook! Ook? if the value in
        # the cell pointed at by the Memory Pointer is non-zero. This involves
        # traversing the ops array backwards.
        #
        elseif op == OP8
            if memory[memory_pointer] != 0x00
                level = 0
                opindex -= 1
                complete = false
                while !complete && opindex >= 1
                    if ops[opindex] == OP8
                        level += 1
                        opindex -= 1
                    elseif ops[opindex] == OP7
                        if level == 0
                            opindex += 1
                            complete = true
                        else
                            level -= 1
                            opindex -= 1
                        end
                    else
                        opindex -= 1
                    end
                end
            else
                opindex += 1
            end

        # Invalid operation
        else
            msg = @sprintf("Unknown op code: %d", ops[opindex])
            throw(ArgumentError(msg))
        end

        if debug
            printafterop(op, memory, memory_pointer)
        end
    end

    return
end

function brainfuck(
    s::String;
    debug::Bool = false,
    io_in::IO = STDIN,
    io_out::IO = STDOUT
)
    interpret(lexandparse(s), debug = debug, io_in = io_in, io_out = io_out)
end
