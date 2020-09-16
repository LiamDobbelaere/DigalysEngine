import dengine_stack
import dengine_memory
import dengine_utils

# TODO: test
proc op_add_int32*(ip: var int32, memory: DEngineMemory, stack: DEngineStack) =
  ## Performs addition of int32 stack contents
  ## <pop:int32> + <pop:int32> => <push:int32>
  let result = (stack.popDword.toInt32 + stack.popDword.toInt32).toBytes
  stack.push([result[3], result[2], result[1], result[0]])

# TODO: test
proc op_add_float32*(ip: var int32, memory: DEngineMemory,
    stack: DEngineStack) =
  ## Performs addition of float32 stack contents
  ## <pop:float32> + <pop:float32> => <push:float32>
  let result = (stack.popDword.toFloat32 + stack.popDword.toFloat32).toBytes
  stack.push([result[3], result[2], result[1], result[0]])

# TODO: test
proc op_push*(ip: var int32, memory: DEngineMemory, stack: DEngineStack) =
  ## Pushes a Dword to the stack (note that it pushes in reverse to help with popping dwords later)
  ## <memory[ip~4..1]:uint8> => <push:dword>
  stack.push([
    memory.get(ip + 4),
    memory.get(ip + 3),
    memory.get(ip + 2),
    memory.get(ip + 1)])
  ip += 4

proc op_out*(ip: var int32, memory: DEngineMemory, stack: DEngineStack) =
  ## Generic output function
  let poppedDword: array[4, uint8] = stack.popDword
  {.noSideEffect.}:
    echo "f32: " & $poppedDword.toFloat32 & "\t\tint32: " &
      $poppedDword.toInt32
