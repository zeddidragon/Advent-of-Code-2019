module advent

import os


pub fn day05() {
  f := os.read_file('input/input05') or {
    println('input05 not found!')
    return
  }
  code_strs := f.split(',')
  mem := code_strs.map(it.int())

  mut mem_clone := arr_copy(mem)
  mut out := intcode(mut mem_clone, 1)
  println(out)

  println('Part 2')
  mem_clone = arr_copy(mem)
  out = intcode(mut mem_clone, 5)
  println(out)
}
