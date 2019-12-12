module advent
import os
import intcode


pub fn day05() {
  f := os.read_file('input/input05') or { panic(err) }
  code_strs := f.split(',')
  mem := code_strs.map(it.i64())
  mut machine := intcode.new(mem)
  machine.feed(1)
  out := machine.run_until_result() or { panic(err) }
  println(int(out))

  // Part 2
  machine = intcode.new(mem)
  machine.feed(5)
  out2 := machine.run_until_result() or { panic(err) }
  println(int(out2))
}
