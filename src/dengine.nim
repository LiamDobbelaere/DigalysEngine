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
    10.3
    0.5
    addf
    out
    10
    8
    addi
    out
  """)

  let runtime = DEngineRuntime()
  runtime.init()

  echo "Bytecode size: " & $compiledCode.len & " bytes"
  echo "VM output:"
  runtime.load(compiledCode)
  runtime.run()



