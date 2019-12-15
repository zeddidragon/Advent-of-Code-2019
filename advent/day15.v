module advent
import os
import intcode

fn navigate_maze(mem []i64) {
  mut tiles := map[string]int
  mut machine := intcode.new(mem)
}

pub fn day15() {
  f := os.read_file('input/input15') or { panic(err) }
  mem_str := f.split(',')
  mem := mem_str.map(it.i64())
}
