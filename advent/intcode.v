module advent

fn intcode(mem mut []int) []int {
  for i := 0; i < mem.len && mem[i] != 99; i += 4 {
    opcode := mem[i]
    a := mem[mem[i + 1]]
    b := mem[mem[i + 2]]
    target := mem[i + 3]
    mem[target] = match opcode {
      1 { a + b }
      2 { a * b }
      else { 0 }
    }
  }

  return mem
}
