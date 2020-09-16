import sequtils

type
  DEngineMemory* = ref object
    ## Serves as the abstraction layer for virtual memory
    memory: seq[uint8]

proc init*(self: DEngineMemory, memSize: int) =
  ## Initialize DEngineMemory with size memSize
  self.memory = sequtils.repeat((uint8)0, memSize)

proc put*(self: DEngineMemory, i: int, value: uint8) =
  ## Put a single value at a memory location
  self.memory[i] = value

proc put*(self: DEngineMemory, i: int, values: openArray[uint8]) =
  ## Put an entire array at once at a specific location
  for offset in 0..<values.len:
    self.memory[i + offset] = values[offset]

proc get*(self: DEngineMemory, i: int): uint8 =
  ## Retrieve a value in memory at location i
  result = self.memory[i]

proc getDword*(self: DEngineMemory, i: int): array[4, uint8] =
  ## Retrieve a Dword in memory at location i
  for j in 0..3:
    result[j] = self.memory[i + j]

proc max*(self: DEngineMemory): int =
  ## Get the highest possible address in memory
  result = self.memory.len - 1

proc size*(self: DEngineMemory): int =
  ## Get the total size of memory
  result = self.memory.len
