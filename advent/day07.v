module advent

import os


fn has_digit(num) {
}

fn generate_phases(length int, base []int) [][]int {
  if base.len >= length {
    return []
  }
  mut accumulator := [][]int
  for i in 0..5 {
    if i in base { continue }
    mut seq := arr_copy(base)
    seq << i
    extracted := generate_phases(length, seq)
    for phase in extracted {
      accumulator << phase
    }
  }
  return accumlator
}

pub fn day07() {
  // f := os.read_file('input/input07') or { panic }
  // code_strs := f.split(',')
  // mem := code_strs.map(it.int())

  phases := generate_phases(5, [])
  println(phases)
}
