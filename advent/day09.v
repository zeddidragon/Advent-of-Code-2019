module advent

import os


pub fn day09() {
  f := os.read_file('input/input09') or { panic(err) }
  code_strs := f.split(',')
  mem := code_strs.map(it.i64())
  mut machine := ic_init(mem)
  machine.feed(1)
  out := machine.run_until_result() or { panic(err) }
  println(out)

  machine = ic_init(mem)
  machine.feed(2)
  out2 := machine.run_until_result() or { panic(err) }
  println(out2)
}

// Pitfalls today:
// Had to convert intcode and a lot of relateed code to i64
// Not really V's fault, but function overloading would've been nice
