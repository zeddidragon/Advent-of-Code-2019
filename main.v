module main
import advent
import flags
import time
import term

fn run(day int, op fn()) {
  only := flags.num('day')
  if only == 0 || day == only {
    before := time.ticks()
    print(term.underline(term.green('Day $day:')))
    op()
    println(term.dim('\t${time.ticks() - before}ms'))
    if flags.has('pretty') { sleep(1) }
  }
}

fn main() {
  run(1, advent.day01)
  run(2, advent.day02)
  run(3, advent.day03)
  run(4, advent.day04)
  run(5, advent.day05)
  run(6, advent.day06)
  run(7, advent.day07)
  run(8, advent.day08)
  run(9, advent.day09)
  run(10, advent.day10)
  run(11, advent.day11)
  run(12, advent.day12)
  run(13, advent.day13)
  run(14, advent.day14)
  run(15, advent.day15)
}
