import unittest
import "../../src/dengine/dengine_utils"

suite "DEngine utils":
  setup:
    discard

  teardown:
    discard

  test "float bytes - toFloat32":
    # 5.54f = 174, 71, 177, 64 in little-endian
    const testValue: array[4, uint8] = [174u8, 71, 177, 64]

    doAssert testValue.toFloat32 == 5.54f

  test "float - toBytes":
    # 174, 71, 177, 64 = 5.54f in little-endian
    const testValue = 5.54f

    doAssert testValue.toBytes == [174u8, 71, 177, 64]

  test "int32 bytes - toInt32":
    # 123456789 = 21, 205, 91, 7 in little-endian
    const testValue: array[4, uint8] = [21u8, 205, 91, 7]

    doAssert testValue.toInt32 == 123456789

  test "int32 - toBytes":
    # 21, 205, 91, 7 = 123456789 in little-endian
    const testValue = 123456789

    doAssert testValue.toBytes == [21u8, 205, 91, 7]

