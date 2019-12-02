module advent

fn intcode(mem mut []int) {
  for i := 0; i < mem.len - 4 && mem[i] != 99; i += 4 {
    opcode := mem[i]
    a_idx := mem[i + 1]
    b_idx := mem[i + 2]
    a := mem[a_idx]
    b := mem[b_idx]
    target := mem[i + 3]
    if target < 0 || target > mem.len - 1 {
      return
    }
    mem[target] = match opcode {
      1 { a + b }
      2 { a * b }
      else { 0 }
    }
  }
}
