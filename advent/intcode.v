module advent

fn intcode(mem mut []int, input int) []int {
  mut jump := 0
  mut output := []int

  for pos := 0; pos < mem.len; pos = jump {
    op := mem[pos]

    argc := match op % 100 {
      1 { 3 }
      2 { 3 }
      3 { 1 }
      4 { 1 }
      5 { 2 }
      6 { 2 }
      7 { 3 }
      8 { 3 }
      else { 0 }
    }
    jump = pos + argc + 1

    mut args := [0].repeat(argc)
    for i := 0; i < argc; i++ {
      idx := pos + i + 1
      v := mem[idx]
      p := pow(10, i + 1)
      mode := (op / p) % 10
      args[i] = match mode {
        0 { mem[v] }
        1 { v }
        else { 0 }
      }
    }

    opcode := op % 100
    $if debug {
      println('op: $op  opc: $opcode')
      println(mem[(pos + 1)..(pos + 1 + argc)])
      println(args)
    }

    match opcode {
      // add
      1 { mem[mem[pos + 3]] = args[0] + args[1] }
      // mul
      2 { mem[mem[pos + 3]] = args[0] * args[1] }
      // read
      3 { mem[mem[pos + 1]] = input }
      // yield
      4 { output << args[0] }
      // if
      5 { if args[0] != 0 { jump = args[1] } }
      // unless
      6 { if args[0] == 0 { jump = args[1] } }
      // lt
      7 {
        v := match args[0] < args[1] {
          true { 1 }
          else { 0 }
        }
        mem[mem[pos + 3]] = v
      }
      // ft
      8 {
        v := match args[0] == args[1] {
          true { 1 }
          else { 0 }
        }
        mem[mem[pos + 3]] = v
      }
    }

    $if debug {
      println('jump: $jump')
    }

  }

  return output
}
