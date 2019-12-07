module advent

import os


pub fn day02() {
  f := os.read_file('input/input02') or { panic }

  code_strs := f.split(',')
  mem := code_strs.map(it.int())

  mut mem_clone := arr_copy(mem)
  mem_clone[1] = 12
  mem_clone[2] = 2
  intcode(mut mem_clone, [])
  println(mem_clone[0])

  println('Part 2')
  for j := 0; j < 100; j++ {
    for i := 0; i < j; i++ {
      mem_clone = arr_copy(mem)
      mem_clone[1] = i
      mem_clone[2] = j
      intcode(mut mem_clone, [])
      if mem_clone[0] == 19690720 {
        p := i * 100 + j
        println('1: $i  2: $j  product: $p')
        return
      }
    }
  }
}

// Pitfalls today:

// https://github.com/vlang/v/issues/2953
// Got a crash on line.split(',').map(it.int())

// Another crash:
// copy := arr.map(it)
// copy = arr.map(it)
// Can't map twice?
