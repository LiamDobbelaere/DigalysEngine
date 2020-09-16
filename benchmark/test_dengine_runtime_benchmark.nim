import unittest
import times
import math
import "../src/dengine/dengine_compiler.nim"
import "../src/dengine/dengine_runtime.nim"

const MAX_BENCHMARK_TIME = 1'f
const RUNTIME_MEMORY = 1024

proc benchCode(code: string) =
  let runtime = DEngineRuntime()
  runtime.init(RUNTIME_MEMORY)

  let compiler = DEngineCompiler()
  compiler.init()

  let bytecode = compiler.compile(code)
  runtime.load(bytecode)

  let time = cpuTime()
  var runs = 0
  while cpuTime() - time < MAX_BENCHMARK_TIME:
    runtime.reset()
    runtime.run()
    runs += 1

  echo $math.round(runs.toFloat / MAX_BENCHMARK_TIME) & " runs/sec for:"

suite "DEngineRuntime benchmarks":
  setup:
    discard

  teardown:
    discard

  test "push 2 integers":
    benchCode("1 2")

  test "push 2 floats":
    benchCode("1.1 2.2")

  test "push 2 integers and addi":
    benchCode("5 4 addi")

  test "push 2 floats and addf":
    benchCode("5.3 1.4 addf")

