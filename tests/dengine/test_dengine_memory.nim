import unittest
import "../../src/dengine/dengine_memory.nim"

suite "DEngineMmemory":
  var memory: DEngineMemory

  setup:
    memory = DEngineMemory()

  teardown:
    discard

  test "put single value":
    const testValue = 220

    memory.init(64)
    memory.put(16, testValue)
    doAssert memory.get(16) == testValue

  test "put multiple values":
    const testValues = @[100u8, 110, 20, 16]

    memory.init(64)
    memory.put(16, testValues)

    for idx, val in pairs(testValues):
      doAssert memory.get(16 + idx) == val

  test "getDword":
    const testValues = @[100u8, 110, 20, 16]

    memory.init(64)
    memory.put(16, testValues)

    doAssert memory.getDword(16) == testValues

  test "size initialization":
    memory.init(64)
    doAssert memory.size == 64

    memory.init(4096)
    doAssert memory.size == 4096

  test "max()":
    memory.init(64)
    doAssert memory.max == 63

    memory.init(4096)
    doAssert memory.max == 4095

