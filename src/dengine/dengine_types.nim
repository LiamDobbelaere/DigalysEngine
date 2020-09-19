import tables
import strutils

type Opcode* = enum
  NOP = 0,  ## do absolutely nothing
  ADDI = 1, ## add the top two values on the stack, reading them as int32
  ADDF = 2, ## add the top two values on the stack, reading them as float32
  PSH = 3,  ## push the next value to the stack as an int32
  OUT = 4,  ## output the value on the stack as text
  JMP = 5,  ## interpret the top value on the stack as a location in memory and set the ip to that location
  DUP = 6,  ## duplicate the value on top of the stack

let stringToOpcode* = { ## Quick conversion table to convert strings to opcodes
  "nop": Opcode.NOP,
  "addi": Opcode.ADDI,
  "addf": Opcode.ADDF,
  "jmp": Opcode.JMP,
  "dup": Opcode.DUP,
  "out": Opcode.OUT
}.toTable

proc toOpcode*(str: string): Opcode =
  result = stringToOpcode[str]

proc isValidOpcode*(str: string): bool =
  result = str in stringToOpcode

# TODO: test
proc isLabel*(str: string): bool =
  result = str.endsWith(":")

# TODO: test
proc isReference*(str: string): bool =
  result = str.startsWith("&")
