module advent

import os


fn generate_phases(max int, mag int, base int) []int{
  if mag >= max {
    return [base]
  }
  mut phases := []int
  for i in 1..6 {
    if has_digit(base, i) { continue }
    next := base + i * pow(10, mag)
    extracted := generate_phases(max, mag + 1, next)
    for phase in extracted {
      phases << phase
    }
  }
  return phases
}

pub fn day07() {
  f := os.read_file('input/input07') or { panic }
  code_strs := f.split(',')
  mem := code_strs.map(it.int())

  mut phases := generate_phases(5, 0, 0)
  for i, v in phases { phases[i] = v - 11111 }

  mut best := 0
  for phase in phases {
    mut out := 0
    for i in 0..5 {
      mut machine := ic_init(mem)
      machine.feed(nth_digit(phase, i))
      machine.run() or { panic(err) }
      machine.feed(out)
      result := machine.run() or { panic(err) }
      out = result.value
    }
    if out > best { best = out }
  }
  println(best)
}
