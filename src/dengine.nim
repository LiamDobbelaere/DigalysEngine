import dengine/dengine_compiler
import dengine/dengine_runtime

when isMainModule:
  # var p = parseopt.initOptParser(os.commandLineParams())
  # var memsize = 2048
  # while true:
  #   p.next()
  #   case p.kind
  #   of cmdEnd: break
  #   of cmdShortOption, cmdLongOption:
  #     if p.val == "":
  #       break
  #     else:
  #       case p.key
  #       of "memsize":
  #         memsize = strutils.parseInt(p.val)

  #   of cmdArgument:
  #     break

  let compiler = DEngineCompiler()
  compiler.init()

  let compiledCode = compiler.compile("""
    addi
  """)

  let runtime = DEngineRuntime()
  runtime.init()

  runtime.load(compiledCode)
  runtime.tick()



