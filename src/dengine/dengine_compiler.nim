import dengine_types
import dengine_utils
import strutils

type
  DEngineCompiler* = ref object
    ## Compiles DEN code to DENB (bytecode that can be executed by the runtime directly)

proc init*(self: DEngineCompiler) =
  ## Initialize DEngineCompiler
  discard

proc parseNonOpcode(self: DEngineCompiler, instruction: string): seq[uint8] =
  if instruction.contains("."):
    # float constant
    result.add(Opcode.PSHF.ord)
    result.add(((float32)parseFloat(instruction)).toBytes)
  else:
    # signed integer constant
    result.add(Opcode.PSHI.ord)
    result.add(((int32)parseInt(instruction)).toBytes)

proc compileInstruction(self: DEngineCompiler, instruction: string): seq[uint8] =
  ## Compiles a single DEN instruction, like 'addi'
  result = @[]

  if instruction.validOpcode:
    let opcodeByte = uint8(instruction.toOpcode())
    result.add(opcodeByte)
  else:
    # Assume this is a constant or variable reference being pushed
    result.add(self.parseNonOpcode(instruction))

proc compile*(self: DEngineCompiler, source: string): seq[uint8] =
  ## Source is expected to be '.den' code
  result = @[]
  for instruction in splitWhitespace(source):
    result &= self.compileInstruction(instruction)
