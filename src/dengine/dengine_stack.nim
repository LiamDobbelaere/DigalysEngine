import dengine_memory

type
  DEngineStack* = ref object
    ## Operates on memory in a stack-like manner, starting from the end of memory
    ## Used to abstract stack operations in the runtime
    memory: DEngineMemory
    sp*: int32 ## Stack pointer (starts at the end of memory, lower index = higher on the stack)

proc init*(self: DEngineStack, memory: DEngineMemory) =
  ## Initialize DEngineStack with size stackSize
  self.memory = memory
  self.sp = (int32)self.memory.max

# TODO: test
proc reset*(self: DEngineStack) =
  self.sp = (int32)self.memory.max

proc push*(self: DEngineStack, value: uint8) =
  ## Push a single value to the stack
  self.memory.put(self.sp, value)
  self.sp -= 1

proc push*(self: DEngineStack, values: openArray[uint8]) =
  ## Push an array of multiple values to the stack
  for i in 0..<values.len:
    self.memory.put(self.sp - i, values[i])
  self.sp -= (int32)values.len

proc pushDwordReverse*(self: DEngineStack, values: array[4, uint8]) =
  ## Push a Dword to the stack, but read values in reverse
  self.memory.put(self.sp, values[values.len - 1])
  self.memory.put(self.sp - 1, values[values.len - 1 - 1])
  self.memory.put(self.sp - 2, values[values.len - 1 - 2])
  self.memory.put(self.sp - 3, values[values.len - 1 - 3])
  self.sp -= 4

proc pop*(self: DEngineStack): uint8 =
  ## Pop a value from the stack
  self.sp += 1
  result = self.memory.get(self.sp)

proc popDword*(self: DEngineStack): array[4, uint8] =
  ## Pop a double word from the stack, more efficient than popping a variable amount
  ## from the stack since no heap is involved
  result[0] = self.memory.get(self.sp + 1)
  result[1] = self.memory.get(self.sp + 2)
  result[2] = self.memory.get(self.sp + 3)
  result[3] = self.memory.get(self.sp + 4)
  self.sp += 4
