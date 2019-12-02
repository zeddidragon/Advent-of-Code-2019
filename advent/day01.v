module advent

import os


fn fuel(weight int) int {
  return max(weight / 3 - 2, 0)
}

fn day01() {
  day(1, 1)
  f := os.read_file('input/input01') or {
    println('input01 not found!')
    return
  }

  mut cost := 0
  mut cost2 := 0
  for line in f.split('\n') {
    mut c := fuel(line.int())
    cost += c
    for ; c > 0; c = fuel(c) {
      cost2 += c
    }
  }
  println(cost)

  day(1, 2)
  println(cost2)
}

// Pitfalls today:

// Running the REPL left garbage .v files in my project,
// need to clean up when compiling the project.

// Documentation didn't mention how to open a file.
// Found it in this example:
// https://github.com/vlang/v/blob/master/examples/word_counter/word_counter.v
// Still no iea how to treat the result of `os.open()`

// No mention of how to turn a string to int
// This answer was outdated:
// https://github.com/vlang/v/issues/273#issuecomment-503515326
// to_i() wasn't found
// from this discussion I found that ints had a method .string(), then tried the reverse.
// https://github.com/vlang/v/issues/2200#issuecomment-537280602

// Guessed my way to math.max()

// math.max seems to only operate on f64?
// wrote my own
