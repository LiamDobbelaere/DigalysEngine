import tables

type Opcode* = enum
  NOP = 0,  ## do absolutely nothing
  ADDI = 1, ## add the top two values on the stack, outputting an int32
  ADDF = 2, ## add the top two values on the stack, outputting a float32
  PSHI = 3, ## push the next value to the stack as an int32
  PSHF = 4, ## push the next value to the stack as a float32

let stringToOpcode* = { ## Quick conversion table to convert strings to opcodes
  "nop": Opcode.NOP,
  "addi": Opcode.ADDI,
  "addf": Opcode.ADDF
}.toTable

proc toOpcode*(str: string): Opcode =
  result = stringToOpcode[str]

proc validOpcode*(str: string): bool =
  result = str in stringToOpcode
