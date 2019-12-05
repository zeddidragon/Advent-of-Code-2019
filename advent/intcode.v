module advent

fn intcode(mem mut []int, input int) []int {
  mut gap := 0
  mut output := []int

  for pos := 0; pos < mem.len; pos += gap {
    op := mem[pos]

    argc := match op % 100 {
      1 { 3 }
      2 { 3 }
      3 { 1 }
      4 { 1 }
      else { 0 }
    }
    gap = argc + 1

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

    match op % 100 {
      1 { mem[mem[pos + 3]] = args[0] + args[1] }
      2 { mem[mem[pos + 3]] = args[0] * args[1] }
      3 { mem[mem[pos + 1]] = input }
      4 { output << args[0] }
      else { break }
    }

  }

  return output
}
