module main

import os
import advent


fn run(day int, only int, op fn()) {
  if only == 0 || day == only {
    println('\nDay: $day\n--------')
    op()
  }
}

fn main() {
  mut day := 0
  for i, arg in os.args {
    if arg == '-day' { day = os.args[i + 1].int() }
  }
  run(1, day, advent.day01)
  run(2, day, advent.day02)
  run(3, day, advent.day03)
  run(4, day, advent.day04)
  run(5, day, advent.day05)
  run(6, day, advent.day06)
  run(7, day, advent.day07)
  run(8, day, advent.day08)
  run(9, day, advent.day09)
  run(10, day, advent.day10)
}
