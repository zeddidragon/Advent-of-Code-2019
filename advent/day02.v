module advent
import os
import intcode


pub fn day02() {
  f := os.read_file('input/input02') or { panic(err) }

  code_strs := f.split(',')
  mut mem := code_strs.map(it.i64())
  mem[1] = 12
  mem[2] = 2
  mut machine := intcode.new(mem)
  machine.run() or { panic(err) }
  println(machine.mem[0])

  for j := 0; j < 100; j++ {
    for i := 0; i < j; i++ {
      mem[1] = i
      mem[2] = j
      machine = intcode.new(mem)
      machine.run() or { panic(err) }
      if machine.mem[0] == 19690720 {
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
