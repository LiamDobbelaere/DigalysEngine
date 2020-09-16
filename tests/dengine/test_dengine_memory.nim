import unittest
import "../../src/dengine/dengine_memory.nim"

suite "DEngineMmemory":
  var memory: DEngineMemory

  setup:
    memory = DEngineMemory()

  teardown:
    discard

  test "put(int, uint8)":
    const testValue = 220

    memory.init(64)
    memory.put(16, testValue)
    doAssert memory.get(16) == testValue, "should put the value in the specific memory location"

  test "put(int, openArray[uint8])":
    const testValues = @[100'u8, 110, 20, 16]

    memory.init(64)
    memory.put(16, testValues)

    for idx, val in pairs(testValues):
      doAssert memory.get(16 + idx) == val, "should put the values in the specific memory locations"

  test "getDword(int)":
    const testValues = @[100'u8, 110, 20, 16]

    memory.init(64)
    memory.put(16, testValues)

    doAssert memory.getDword(16) == testValues, "should return the Dword at the specific memory location"

  test "size()":
    memory.init(64)
    doAssert memory.size == 64, "should return the correct size"

    memory.init(4096)
    doAssert memory.size == 4096, "should return the correct size"

  test "max()":
    memory.init(64)
    doAssert memory.max == 63, "should return the highest memory address"

    memory.init(4096)
    doAssert memory.max == 4095, "should return the highest memory address"

