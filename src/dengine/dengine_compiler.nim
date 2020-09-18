import dengine_types
import dengine_utils
import strutils
import tables

type
  DEngineCompiler* = ref object
    ## Compiles DEN code to DENB (bytecode that can be executed by the runtime directly)
    labels: Table[string, int]

proc init*(self: DEngineCompiler) =
  ## Initialize DEngineCompiler
  self.labels = initTable[string, int]()

proc parseNonOpcode(self: DEngineCompiler, instruction: string): seq[uint8] =
  if instruction.contains("."):
    # float constant
    result.add(Opcode.PSH.ord)
    result.add(((float32)parseFloat(instruction)).toBytes)
  else:
    # signed integer constant
    result.add(Opcode.PSH.ord)
    result.add(((int32)parseInt(instruction)).toBytes)

proc compileInstruction(self: DEngineCompiler, instruction: string): seq[uint8] =
  ## Compiles a single DEN instruction, like 'addi'
  result = @[]

  if instruction.validOpcode:
    let opcodeByte = uint8(instruction.toOpcode())
    result.add(opcodeByte)
  elif instruction.endsWith(":"):
    self.labels[instruction.replace(":", "")] = 0
    # should be result.length - 1, but you'll have to pass the entire program to here instead of making a new sequence,
    # maybe just make the compiled program a property of self instead
  else:
    # Assume this is a constant or variable reference being pushed
    result.add(self.parseNonOpcode(instruction))

proc compile*(self: DEngineCompiler, source: string): seq[uint8] =
  ## Source is expected to be '.den' code
  result = @[]
  for instruction in splitWhitespace(source):
    result &= self.compileInstruction(instruction)
