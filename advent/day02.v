module advent

import os


pub fn day02() {
  f := os.read_file('input/input02') or { panic(err) }

  code_strs := f.split(',')
  mut mem := code_strs.map(it.int())
  mem[1] = 12
  mem[2] = 2
  mut machine := ic_init(mem)
  machine.run() or { panic }
  println(machine.mem[0])

  for j := 0; j < 100; j++ {
    for i := 0; i < j; i++ {
      mem[1] = i
      mem[2] = j
      machine = ic_init(mem)
      machine.run() or { panic(err) }
      if machine.mem[0] == 19690720 {
        p := i * 100 + j
        println(i * 100 + j)
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
