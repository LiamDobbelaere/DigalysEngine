import dengine_types
import dengine_utils
import strutils

type
  DEngineCompiler* = ref object
    ## Compiles den code to denb (bytecode that can be executed by the runtime directly)

proc init*(self: DEngineCompiler) =
  ## Initialize DEngineCompiler
  discard

proc compileInstruction(self: DEngineCompiler, instruction: string): seq[uint8] =
  ## Compiles a single '.den' instruction, like 'add'
  result = @[]

  if instruction.validOpcode:
    let opcodeByte = uint8(instruction.toOpcode())
    result.add(opcodeByte)
  else:
    # Assume this is a constant or variable reference being pushed
    result.add(Opcode.PSH.ord)
    result.add(parseFloat(instruction).toBytes)

# TODO: test
proc compile*(self: DEngineCompiler, source: string): seq[uint8] =
  ## Source is expected to be '.den' code
  result = @[]
  for instruction in splitWhitespace(source):
    result &= self.compileInstruction(instruction)
