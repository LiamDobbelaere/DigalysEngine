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

proc put*(self: DEngineMemory, i: int, values: seq[uint8]) =
  ## Put an entire array at once at a specific location
  for idx, val in values:
    self.memory[i + idx] = val

proc get*(self: DEngineMemory, i: int): uint8 =
  ## Retrieve a value in memory
  result = self.memory[i]

# TODO: test
proc max*(self: DEngineMemory): int =
  ## Get the highest possible address in memory
  result = self.memory.len - 1

proc size*(self: DEngineMemory): int =
  ## Get the total size of memory
  result = self.memory.len
