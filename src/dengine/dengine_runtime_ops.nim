import dengine_stack
import dengine_memory
import dengine_utils

proc op_add_int32*(ip: var int32, memory: DEngineMemory, stack: DEngineStack) =
  ## Performs addition of int32 stack contents
  ## <pop:int32> + <pop:int32> => <push:int32>
  let result = (stack.popDword.toInt32 + stack.popDword.toInt32).toBytes
  stack.pushDwordReverse(result)
  ip += 1

proc op_add_float32*(ip: var int32, memory: DEngineMemory,
    stack: DEngineStack) =
  ## Performs addition of float32 stack contents
  ## <pop:float32> + <pop:float32> => <push:float32>
  let result = (stack.popDword.toFloat32 + stack.popDword.toFloat32).toBytes
  stack.pushDwordReverse(result)
  ip += 1

proc op_push*(ip: var int32, memory: DEngineMemory, stack: DEngineStack) =
  ## Pushes a Dword to the stack (note that it pushes in reverse to help with popping dwords later)
  ## <memory[ip~4..1]:uint8> => <push:dword>
  stack.pushDwordReverse(memory.getDword(ip + 1))
  ip += 5

proc op_jump*(ip: var int32, memory: DEngineMemory, stack: DEngineStack) =
  ## Jumps to the address on top of the stack
  ## ip = <pop:int32>
  ip = stack.popDword.toInt32

proc op_duplicate*(ip: var int32, memory: DEngineMemory, stack: DEngineStack) =
  ## Duplicate the value on top of the stack
  ## <push:int32>
  stack.pushDwordReverse(stack.peekDword)
  ip += 1

proc op_nop*(ip: var int32, memory: DEngineMemory, stack: DEngineStack) =
  ## Do nothing
  ip += 1

proc op_out*(ip: var int32, memory: DEngineMemory, stack: DEngineStack) =
  ## Generic output function
  let poppedDword: array[4, uint8] = stack.popDword
  {.noSideEffect.}:
    echo "f32: " & $poppedDword.toFloat32 & "\t\tint32: " &
      $poppedDword.toInt32
  ip += 1
