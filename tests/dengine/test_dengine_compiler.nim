import unittest
import "../../src/dengine/dengine_compiler.nim"
import "../../src/dengine/dengine_types.nim"

suite "DEngineCompiler - snapshot tests":
  var compiler: DEngineCompiler

  setup:
    compiler = DEngineCompiler()
    compiler.init()

  teardown:
    discard

  test "single 'addi' instruction":
    let result = compiler.compile("""
      addi
    """)

    doAssert result == [(uint8)Opcode.ADDI]

  test "push constant float value":
    let result = compiler.compile("""
      5.54
    """)

    doAssert result == [(uint8)Opcode.PSH, 174u8, 71, 177, 64]

  test "push constant integer value":
    let result = compiler.compile("""
      123456789
    """)

    doAssert result == [(uint8)Opcode.PSH, 21, 205, 91, 7]
