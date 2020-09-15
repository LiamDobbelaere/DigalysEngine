import sequtils

type
  DEngineStack* = ref object
    ## This is a fixed-size, custom stack implementation which should not cause reallocations
    ## It's not actually used for the stack itself in the runtime, but for the stack metadata
    stack: seq[uint8]
    sp: int32

# TODO: test
proc init*(self: DEngineStack, stackSize: int) =
  ## Initialize DEngineStack with size stackSize
  self.stack = sequtils.repeat((uint8)0, stackSize)
  self.sp = 0

# TODO: test
proc push*(self: DEngineStack, value: uint8) =
  ## Push a single value to the stack
  self.stack[self.sp] = value
  self.sp += 1

# TODO: test
proc push*(self: DEngineStack, values: seq[uint8]) =
  ## Push an array of multiple values to the stack
  for idx, val in values:
    self.stack[self.sp] = val
    self.sp += 1

# TODO: test
proc pop*(self: DEngineStack): uint8 =
  ## Pops a value from the stack, returning it
  self.sp -= 1
  result = self.stack[self.sp]

# TODO: test
proc peek*(self: DEngineStack): uint8 =
  ## Peek at what's on top of the stack
  result = self.stack[self.sp - 1]

# TODO: test
proc peek*(self: DEngineStack, offset: int): uint8 =
  ## Peek at what's on top of the stack, with an offset
  result = self.stack[self.sp - 1 - offset]
