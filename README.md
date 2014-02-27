Brainfuck.jl
======

A [Brainfuck](www) interpreter written in Julia. Because `<-->`.

# Usage Example

Execute a string containing a Brainfuck program using the `brainfuck` function:

```
using Brainfuck
brainfuck("<-->")
```

To work with a program stored in a file, use `readall` to generate a string
to pass to `brainfuck`:

```
using Brainfuck
path = Pkg.dir("Brainfuck", "test", "programs", "hello2.bfk")
brainfuck(readall(path))
```

If you want to observe the program state evolve operation-by-operation, you
can set the `debug` keyword argument to `false` when running `brainfuck`:

```
using Brainfuck
path = Pkg.dir("Brainfuck", "test", "programs", "hello2.bfk")
brainfuck(readall(path), debug = true)
```

*Be warned that the state evolution of the Brainfuck interpreter will produce
a lot of output for even the simplest programs.*

# Brainfuck Language Reference

**OP1: `>`**

Move the Memory Pointer to the next array cell.

**OP2: `<`**

Move the Memory Pointer to the previous array cell.

**OP3: `+`**

Increment the array cell pointed at by the Memory Pointer.

**OP4: `-`**

Decrement the array cell pointed at by the Memory Pointer.

**OP5: `,`**

Read a character from STDIN and put its ASCII value into the cell
pointed at by the Memory Pointer.

**OP6: `.`**

Print the character with ASCII value equal to the value in the cell
pointed at by the Memory Pointer.

**OP7: `[`**

Move to the command following the matching `]` if the value in
the cell pointed at by the Memory Pointer is zero. Note that
`[` and `]` commands nest like pairs of parentheses, and
matching pairs are defined in the same way as for parentheses.

**OP8: `]`**

Move to the command following the matching `[` if the value in
the cell pointed at by the Memory Pointer is non-zero. **Note that this
implies that the interpreter will work its way backwards through the
source code, rather than forwards.**
