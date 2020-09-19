import dengine_types
import dengine_utils
import strutils
import tables

type
  DEngineCompiler* = ref object
    ## Compiles DEN code to DENB (bytecode that can be executed by the runtime directly)

type
  CompilationData* = ref object
    ## Holds the current compilation's data like bytecode, label locations etc.
    ## It's used because the compilation functions take a lot of arguments
    ##
    ## If we don't put it in DEngineCompiler but pass around this object instead,
    ## it makes those compilation functions more testable
    labels: Table[string, int] # Label names mapped to their locations
    labelReferences: Table[int, string] # References that have not been filled mapped to their labels
    bytecode: seq[uint8] # The compiled code up until now
    instruction: string # The current instruction

proc init*(self: CompilationData) =
  ## Initialize the compilation data, which holds all current compilation-related data
  self.labels = initTable[string, int]()
  self.labelReferences = initTable[int, string]()
  self.bytecode = @[]

proc init*(self: DEngineCompiler) =
  ## Initialize DEngineCompiler
  discard

proc compileConstant(self: DEngineCompiler, cd: CompilationData) =
  if cd.instruction.contains("."):
    # float constant
    cd.bytecode.add(Opcode.PSH.ord)
    cd.bytecode.add(((float32)parseFloat(cd.instruction)).toBytes)
  else:
    # signed integer constant
    cd.bytecode.add(Opcode.PSH.ord)
    cd.bytecode.add(((int32)parseInt(cd.instruction)).toBytes)

proc compileOpcode(self: DEngineCompiler, cd: CompilationData) =
  let opcodeByte = cd.instruction.toOpcode()
  cd.bytecode.add((uint8)opcodeByte)

proc compileLabel(self: DEngineCompiler, cd: CompilationData) =
  cd.labels[cd.instruction.replace(":", "")] = cd.bytecode.len

proc compileReference(self: DEngineCompiler, cd: CompilationData) =
  cd.labelReferences[cd.bytecode.len + 1] = cd.instruction.replace("&", "")
  cd.bytecode.add(Opcode.PSH.ord)
  cd.bytecode.add(0.toBytes)

proc compileInstruction(self: DEngineCompiler, cd: CompilationData) =
  ## Compiles a single DEN instruction

  if cd.instruction.isValidOpcode: # Simple opcode: 'addi'
    self.compileOpcode(cd)
  elif cd.instruction.isLabel: # Label definition: 'myLabel:'
    self.compileLabel(cd)
  elif cd.instruction.isReference: # Reference to label or memory location: '&myLabel'
    self.compileReference(cd)
  else: # Constant value: '5.7' (float32) or '5' (int32)
    self.compileConstant(cd)

proc compile*(self: DEngineCompiler, source: string): seq[uint8] =
  ## Source is expected to be '.den' code

  var cd = CompilationData()
  cd.init()

  for instruction in splitWhitespace(source):
    cd.instruction = instruction
    self.compileInstruction(cd)

  # Post-pass to replace all label references with their definitive versions
  for labelRefLocation in cd.labelReferences.keys:
    let finalLocation = ((int32)cd.labels[cd.labelReferences[
        labelRefLocation]]).toBytes
    cd.bytecode[labelRefLocation] = finalLocation[0]
    cd.bytecode[labelRefLocation + 1] = finalLocation[1]
    cd.bytecode[labelRefLocation + 2] = finalLocation[2]
    cd.bytecode[labelRefLocation + 3] = finalLocation[3]

  result = cd.bytecode
