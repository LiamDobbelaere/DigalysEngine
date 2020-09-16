import unittest
import "../../src/dengine/dengine_utils"

suite "DEngine utils":
  setup:
    discard

  teardown:
    discard

  test "toFloat32(bytes)":
    # 5.54f = 174, 71, 177, 64 in little-endian
    const testValue: array[4, uint8] = [174u8, 71, 177, 64]

    doAssert testValue.toFloat32 == 5.54f, "should convert an array of float32 bytes into a float32"

  test "toBytes(float32)":
    # 174, 71, 177, 64 = 5.54f in little-endian
    const testValue = 5.54f

    doAssert testValue.toBytes == [174u8, 71, 177, 64], "should explode a float32 into its byte components"

  test "toInt32(bytes)":
    # 123456789 = 21, 205, 91, 7 in little-endian
    const testValue: array[4, uint8] = [21u8, 205, 91, 7]

    doAssert testValue.toInt32 == 123456789, "should convert an array of int32 bytes into an int32"

  test "toBytes(int32)":
    # 21, 205, 91, 7 = 123456789 in little-endian
    const testValue = 123456789

    doAssert testValue.toBytes == [21u8, 205, 91, 7], "should explode an int32 into its byte components"

