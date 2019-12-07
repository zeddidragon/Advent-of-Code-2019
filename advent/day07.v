module advent

import os


fn max_output(mem []int, n int, output int, exclude []int) int {
  if n == 0 { return output }

  mut max_out := 0
  for i in 0..5 {
    if i in exclude { continue }
    next_mem := arr_copy(mem)
    copied := arr_copy(mem)
    result := intcode(mut copied, [i, output])
    mut next_exclude := arr_copy(exclude)
    next_exclude << i
    max_out = max(max_out, max_output(mem, n - 1, result[0], next_exclude))
  }

  return max_out
}


pub fn day07() {
  f := os.read_file('input/input07') or { panic }
  code_strs := f.split(',')
  mem := code_strs.map(it.int())

  println(max_output(mem, 5, 0, []))
  println('Part 2')
}
