import tables

type Opcode* = enum
  NOP = 0,  ## do absolutely nothing
  ADDI = 1, ## add the top two values on the stack, reading them as int32
  ADDF = 2, ## add the top two values on the stack, reading them as float32
  PSH = 3,  ## push the next value to the stack as an int32
  OUT = 4,  ## output the value on the stack as text

let stringToOpcode* = { ## Quick conversion table to convert strings to opcodes
  "nop": Opcode.NOP,
  "addi": Opcode.ADDI,
  "addf": Opcode.ADDF,
  "out": Opcode.OUT
}.toTable

proc toOpcode*(str: string): Opcode =
  result = stringToOpcode[str]

proc validOpcode*(str: string): bool =
  result = str in stringToOpcode
