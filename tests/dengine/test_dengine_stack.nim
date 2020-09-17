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

  test "init()":
    doAssert stack.sp == memory.max, "should set the stack pointer to the end of memory"

  test "push(uint8)":
    stack.push(5)

    doAssert stack.sp == memory.max - 1, "should decrease stack pointer back by one"
    doAssert memory.get(memory.max) == 5, "should put the value at the pre-call stack pointer's location"

  test "push(openArray[uint8])":
    stack.push([5'u8, 6])

    doAssert stack.sp == memory.max - 2, "should decrease stack pointer by the length of the input values"
    doAssert memory.get(memory.max) == 5, "should put the values in memory, starting at the pre-call stack pointer's location"
    doAssert memory.get(memory.max - 1) == 6, "should put the values in memory, starting at the pre-call stack pointer's location"

  test "pushDwordReverse(openArray[uint8])":
    stack.pushDwordReverse([5'u8, 6, 7, 8])

    doAssert stack.sp == memory.max - 4, "should decrease stack pointer by the length of the input values"
    doAssert memory.get(memory.max) == 8, "should put the values in memory in reverse, starting at the pre-call stack pointer's location"
    doAssert memory.get(memory.max - 1) == 7, "should put the values in memory in reverse, starting at the pre-call stack pointer's location"
    doAssert memory.get(memory.max - 2) == 6, "should put the values in memory in reverse, starting at the pre-call stack pointer's location"
    doAssert memory.get(memory.max - 3) == 5, "should put the values in memory in reverse, starting at the pre-call stack pointer's location"

  test "pop()":
    stack.push([5'u8, 6])
    let poppedValue = stack.pop()

    doAssert poppedValue == 6, "should return the value that was at the top of the stack"
    doAssert stack.sp == memory.max - 1, "should decrease stack pointer by one"

  test "popDword()":
    stack.push([5'u8, 6, 7, 8, 9, 10, 11, 12])
    let poppedValue = stack.popDword()

    doAssert poppedValue == [12'u8, 11, 10, 9], "should return the Dword that was at the top of the stack"
    doAssert stack.sp == memory.max - 4, "should decrease stack pointer by 4 (size of a Dword)"
