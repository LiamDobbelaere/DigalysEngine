import dengine/dengine_memory
import os
import strutils
import parseopt

when isMainModule:
  var p = parseopt.initOptParser(os.commandLineParams())
  var memsize = 2048
  while true:
    p.next()
    case p.kind
    of cmdEnd: break
    of cmdShortOption, cmdLongOption:
      if p.val == "":
        break
      else:
        case p.key
        of "memsize":
          memsize = strutils.parseInt(p.val)

    of cmdArgument:
      break

  let mem = DEngineMemory()
  mem.init(memsize)
  echo mem.len
  mem[0] = 5
  echo("Hello, World!")
  echo mem[0]


