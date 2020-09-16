# Package

version       = "0.1.0"
author        = "Tom Dobbelaere"
description   = "Digaly's Engine"
license       = "GPL-2.0"
srcDir        = "src"
bin           = @["dengine"]

# Dependencies

requires "nim >= 1.2.6"

task tests, "Run tests":
  exec "nimble test --silent"

task bench, "Run benchmark":
  exec "nim c --hints:off --outdir=build -r ./benchmark/test_dengine_runtime_benchmark.nim"