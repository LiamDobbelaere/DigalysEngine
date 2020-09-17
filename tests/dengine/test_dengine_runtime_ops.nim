import unittest
import "../../src/dengine/dengine_stack.nim"
import "../../src/dengine/dengine_memory.nim"
import "../../src/dengine/dengine_runtime_ops.nim"
import "../../src/dengine/dengine_utils.nim"

suite "DEngineRuntime operations":
  var memory: DEngineMemory
  var stack: DEngineStack
  var ip: int32

  setup:
    memory = DEngineMemory()
    memory.init(512)

    stack = DEngineStack()
    stack.init(memory)

    ip = 0

  teardown:
    discard

  test "op_add_int32":
    stack.pushDwordReverse(5.toBytes)
    stack.pushDwordReverse(4.toBytes)

    op_add_int32(ip, memory, stack)

    doAssert stack.popDword() == 9.toBytes, "should add the two int32s on the stack, pushing the resulting int32 to the stack"

  test "op_add_float32":
    stack.pushDwordReverse(5.5.toBytes)
    stack.pushDwordReverse(0.5.toBytes)

    op_add_float32(ip, memory, stack)

    doAssert stack.popDword() == 6.0.toBytes, "should add the two float32s on the stack, pushing the resulting float32 to the stack"

  test "op_push":
    memory.put(1, [1'u8, 2, 3, 4])

    op_push(ip, memory, stack)

    doAssert stack.popDword() == [1'u8, 2, 3, 4], "should push the Dword in memory to the stack"
