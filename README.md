# Digaly's Engine

## Roadmap (chronological top to bottom)

- Binary mode  
  Note: Liberties should be taken here where necessary, it's not the goal to be 100% realistic
  - ~~Memory: Fixed size at runtime, but adjustable through params~~
  - Compiler: Compile `den` files to bytecode, start with simple instruction set (output?)
  - Runtime: Load program instructions into memory
  - I/O: output to stdout (numbers/bytes)
  - Code: data segments
  - I/O: output to stdout (strings)
  - Code: Comments
  - Memory: Stack
  - Code: Label support
  - Code: Jumps
  - Code: main label
  - Code: Conditional jumps:
    is zero, is not zero, is equal, is not equal, is greater (equal), is less (equal) + duplicate top of stack equivalents
  - Code: Procedure calls (+ return)
  - Code: Variables store/load
  - Code: Locally scoped variables (stack frames)
  - Memory: Heap
  - I/O: input through stdin
- Terminal mode
- Graphics mode
- Extensions
