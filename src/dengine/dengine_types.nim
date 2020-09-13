import tables

type Opcode* = enum
  OUT = 1, ## PSH [value]  - push a value to the stack

const stringToOpcode = { ## Quick conversion table to convert strings to opcodes
  "out": Opcode.OUT,
}.toTable

proc toOpcode*(str: string): Opcode =
  result = stringToOpcode[str]
