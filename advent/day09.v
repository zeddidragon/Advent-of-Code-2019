module advent

import os


pub fn day09() {
  // f := os.read_file('input/input09') or { panic(err) }
  // code_strs := f.split(',')
  // mem := code_strs.map(it.i64())
  mem := [i64(1102),34915192,34915192,7,4,7,99,0]
  mut machine := ic_init(mem)
  machine.feed(1)
  out := machine.run_until_result() or { panic(err) }
  println(out)
}
