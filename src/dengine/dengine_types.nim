import tables

type Opcode* = enum
  NOP = 0,  ## do absolutely nothing
  ADDI = 1, ## add the top two values on the stack, outputting an int32
  ADDF = 2, ## add the top two values on the stack, outputting a float32
  PSHI = 3, ## push the next value to the stack as an int32
  PSHF = 4, ## push the next value to the stack as a float32
  OUT = 5,  ## output the value on the stack as text

# TODO: StackFlags need to go, will become unused
type StackFlag* = enum
  SF_NONE = 0,  ## No extra information for the stack entry
  SF_INT = 1,   ## Entry should be seen as an int32
  SF_FLOAT = 2, ## Entry should be seen as a float32

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
