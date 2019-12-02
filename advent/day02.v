module advent

import os



fn day02() {
  day(1, 1)
  f := os.read_file('input/input02') or {
    println('input02 not found!')
    return
  }

  mut codeStr := f.split(',').map(it.int())
  println('code: $code')
}

// Pitfalls today:

// https://github.com/vlang/v/issues/2953
// Got a crash on line.split(',').map(it.int())
