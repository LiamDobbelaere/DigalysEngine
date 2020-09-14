import tables

type Opcode* = enum
  ADD = 1, ## add the top two values on the stack
  PSH = 2  ## push the next value to the stack

let stringToOpcode* = { ## Quick conversion table to convert strings to opcodes
  "add": Opcode.ADD,
}.toTable

proc toOpcode*(str: string): Opcode =
  result = stringToOpcode[str]

proc validOpcode*(str: string): bool =
  result = str in stringToOpcode
