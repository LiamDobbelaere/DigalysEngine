import dengine_types
import dengine_memory
import dengine_stack
import dengine_utils
import tables

# TODO 16/09/2020:
# Trash the idea of converting floats to ints at runtime if addi is used
# It's not only slower but the code is more confusing because of it anyway
# 4 bytes is 4 bytes, and it's up to the caller to call the right method to add mixed types
# In other words, addf will ALWAYS pull floats from the stack, whether they actually are floats or not
# -> this means new instructions are needed for working with mixed types
# I can delete a lot of code because of it, and it'll be easier in the long run

type
  DEngineRuntime* = ref object
    ## This is the VM itself, the runtime executes bytecode generated by the compiler
    ##
    ## Note: The actual VM stack is implemented as a region in memory, starting from the end.
    ## DEngineStack on the other hand is a stack implementation used to hold metadata related
    ## to this actual stack, and thus is not used to hold the actual VM's stack values
    memory: DEngineMemory
    stackMetadata: DEngineStack ## Contains additional info about what's on the stack, used to do runtime type conversions
    programSize: int ## Holds the length of the currently loaded program
    ip: int32 ## Instruction pointer (starts at the beginning of memory)
    sp: int32 ## Stack pointer (starts at the end of memory, lower index = higher on the stack)

proc init*(self: DEngineRuntime) =
  ## Initialize DEngineRuntime

  # Set up memory, fixed at 512 bytes large for now
  self.memory = DEngineMemory()
  self.memory.init(512)

  # Set up the stack metadata
  self.stackMetadata = DEngineStack()
  self.stackMetadata.init(1024)

# TODO: test
proc load*(self: DEngineRuntime, program: seq[uint8]) =
  ## Load a program (DEN bytecode) into memory
  self.memory.put(0, program)
  self.programSize = program.len
  self.ip = 0 # Start the instruction pointer at the beginning of memory
  self.sp = (int32)self.memory.max # Start the stack pointer at the end of memory

# TODO: test
proc stackPush(self: DEngineRuntime, value: uint8) =
  ## Push a single value to the stack
  self.memory.put(self.sp, value)
  self.sp -= 1

# TODO: test
proc stackPush(self: DEngineRuntime, values: openArray[uint8]) =
  ## Push an array of multiple values to the stack
  for idx, val in values:
    self.memory.put(self.sp, val)
    self.sp -= 1

# TODO: test
proc stackPop(self: DEngineRuntime): uint8 =
  ## Pop a value from the stack
  self.sp += 1
  self.memory.get(self.sp)

# TODO: ~test~ actually delete
proc stackPopInt32(self: DEngineRuntime): int32 =
  ## Pop a value from the stack, convert to int32
  let metadata: StackFlag = (StackFlag)self.stackMetadata.pop()
  # TODO: extract below repeated code to stackPop(length: int): seq[uint8]
  let bytes: array[4, uint8] = [
    self.stackPop(), self.stackPop(), self.stackPop(), self.stackPop()
  ]

  if metadata == SF_FLOAT:
    result = (int32)bytes.toFloat32().toInt()
  elif metadata == SF_INT:
    result = bytes.toInt32()
  else:
    echo "Unknown metadata, not good"

# TODO: ~test~ actually delete
proc stackPopFloat32(self: DEngineRuntime): float32 =
  ## Pop a value from the stack, convert to float32
  let metadata: StackFlag = (StackFlag)self.stackMetadata.pop()
  # TODO: extract below repeated code to stackPop(length: int): seq[uint8]
  let bytes: array[4, uint8] = [
    self.stackPop(), self.stackPop(), self.stackPop(), self.stackPop()
  ]

  if metadata == SF_FLOAT:
    result = bytes.toFloat32()
  elif metadata == SF_INT:
    result = bytes.toInt32().toFloat()
  else:
    echo "Unknown metadata, not good"

# TODO: test
proc op_addi(runtime: DEngineRuntime) =
  let result = ((int32)runtime.stackPopInt32() + (int32)runtime.stackPopInt32()).toBytes
  runtime.stackPush(result[3])
  runtime.stackPush(result[2])
  runtime.stackPush(result[1])
  runtime.stackPush(result[0])
  runtime.stackMetadata.push((uint8)StackFlag.SF_INT)

# TODO: test
proc op_addf(runtime: DEngineRuntime) =
  let result = ((float32)runtime.stackPopFloat32() + (
      float32)runtime.stackPopFloat32()).toBytes
  # TODO: provide cleaner routine to do this
  runtime.stackPush(result[3])
  runtime.stackPush(result[2])
  runtime.stackPush(result[1])
  runtime.stackPush(result[0])
  runtime.stackMetadata.push((uint8)StackFlag.SF_FLOAT)

# TODO: test
proc op_pshi(runtime: DEngineRuntime) =
  runtime.stackPush(runtime.memory.get(runtime.ip + 4))
  runtime.stackPush(runtime.memory.get(runtime.ip + 3))
  runtime.stackPush(runtime.memory.get(runtime.ip + 2))
  runtime.stackPush(runtime.memory.get(runtime.ip + 1))
  runtime.ip += 4
  runtime.stackMetadata.push((uint8)StackFlag.SF_INT)

# TODO: test
proc op_pshf(runtime: DEngineRuntime) =
  runtime.stackPush(runtime.memory.get(runtime.ip + 4))
  runtime.stackPush(runtime.memory.get(runtime.ip + 3))
  runtime.stackPush(runtime.memory.get(runtime.ip + 2))
  runtime.stackPush(runtime.memory.get(runtime.ip + 1))
  runtime.ip += 4
  runtime.stackMetadata.push((uint8)StackFlag.SF_FLOAT)

# TODO: test
proc op_out(runtime: DEngineRuntime) =
  let metadata: StackFlag = (StackFlag)runtime.stackMetadata.peek()

  if metadata == SF_FLOAT:
    echo runtime.stackPopFloat32()
  elif metadata == SF_INT:
    echo runtime.stackPopInt32()
  else:
    echo "Unknown metadata, not good"


proc execute(self: Opcode, runtime: DEngineRuntime) =
  ## Maps opcodes to procedures that handle them and executes it
  {
    Opcode.ADDI: op_addi,
    Opcode.ADDF: op_addf,
    Opcode.PSHI: op_pshi,
    Opcode.PSHF: op_pshf,
    Opcode.OUT: op_out
  }.toTable[self](runtime)

# TODO: test
proc tick*(self: DEngineRuntime) =
  ## Grab the current instruction, interpret it as an opcode and execute it
  ((Opcode)self.memory.get(self.ip)).execute(self)
  self.ip += 1

# TODO: test
proc run*(self: DEngineRuntime) =
  ## Run all code at once
  while self.ip < self.programSize:
    self.tick()