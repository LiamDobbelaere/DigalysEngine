import unittest
import algorithm
import "../../src/dengine/dengine_stack.nim"
import "../../src/dengine/dengine_memory.nim"
import "../../src/dengine/dengine_runtime_ops.nim"
import "../../src/dengine/dengine_utils.nim"

suite "DEngineRuntime - ops":
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
    stack.pushReverse(5.toBytes)
    stack.pushReverse(4.toBytes)

    op_add_int32(ip, memory, stack)

    doAssert stack.popDword() == 9.toBytes

  test "op_add_float32":
    stack.pushReverse(5.5.toBytes)
    stack.pushReverse(0.5.toBytes)

    op_add_float32(ip, memory, stack)

    doAssert stack.popDword() == 6.0.toBytes

  test "op_push":
    memory.put(1, [1u8, 2, 3, 4])

    op_push(ip, memory, stack)

    doAssert stack.popDword() == [1u8, 2, 3, 4]
