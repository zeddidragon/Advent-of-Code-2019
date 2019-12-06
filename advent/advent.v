module advent

import os

fn run(day int, only int, op fn()) {
  if only == 0 || day == only {
    println('Day: $day')
    op()
  }
}

pub fn code() {
  mut day := 0
  for i, arg in os.args {
    if arg == '-day' { day = os.args[i + 1].int() }
  }
  println(os.args)
  run(1, day, day01)
  run(2, day, day02)
  run(3, day, day03)
  run(4, day, day04)
  run(5, day, day05)
}
