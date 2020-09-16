import unittest
import "../../src/dengine/dengine_stack.nim"
import "../../src/dengine/dengine_memory.nim"

suite "DEngineStack":
  var stack: DEngineStack
  var memory: DEngineMemory

  setup:
    memory = DEngineMemory()
    memory.init(512)

    stack = DEngineStack()
    stack.init(memory)

  teardown:
    discard

  test "init":
    doAssert stack.sp == memory.max

  test "push single":
    stack.push(5)

    doAssert stack.sp == memory.max - 1
    doAssert memory.get(memory.max) == 5

  test "push multiple":
    stack.push([5u8, 6])

    doAssert stack.sp == memory.max - 2
    doAssert memory.get(memory.max) == 5
    doAssert memory.get(memory.max - 1) == 6

  test "push multiple reverse":
    stack.pushReverse([5u8, 6])

    doAssert stack.sp == memory.max - 2
    doAssert memory.get(memory.max) == 6
    doAssert memory.get(memory.max - 1) == 5

  test "pop single":
    stack.push([5u8, 6])
    let poppedValue = stack.pop()

    doAssert poppedValue == 6
    doAssert stack.sp == memory.max - 1

  test "pop dword":
    stack.push([5u8, 6, 7, 8, 9, 10, 11, 12])
    let poppedValue = stack.popDword()

    doAssert poppedValue == [12u8, 11, 10, 9]
    doAssert stack.sp == memory.max - 4
