import sequtils

type
  DEngineMemory* = ref object
    memory: seq[uint8]

proc init*(self: DEngineMemory, memSize: int) =
  self.memory = sequtils.repeat((uint8)0, memSize)

proc `[]=`*(self: DEngineMemory, i: int, value: uint8) =
  self.memory[i] = value

proc `[]`*(self: DEngineMemory, i: int): uint8 =
  result = self.memory[i]

proc len*(self: DEngineMemory): int =
  result = self.memory.len
