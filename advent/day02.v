module advent

import os


fn day02() {
  day(2, 1)
  f := os.read_file('input/input02') or {
    println('input02 not found!')
    return
  }

  code_strs := f.split(',')
  mem := code_strs.map(it.int())

  mut mem_clone := mem.map(it)
  mem_clone[1] = 12
  mem_clone[2] = 2
  mem_clone = intcode(mut mem)
  v0 := mem_clone[0]
  println('Value 0: $v0')

  day(2, 2)
  for j := 0; j < 100; j++ {
    for i := 0; i < j; i++ {
      mem_clone = mem.map(it)
      mem_clone[1] = i
      mem_clone[2] = j
      mem_clone = intcode(mut mem)
      v0 := mem_clone[0]
      if v0 == 19690720 {
        p := i * 100 + j
        println('1: $i  2: $j  product: $p')
      }
    }
  }
}

// Pitfalls today:

// https://github.com/vlang/v/issues/2953
// Got a crash on line.split(',').map(it.int())
