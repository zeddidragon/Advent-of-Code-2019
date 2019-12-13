module advent
import os
import intcode
import imath


fn generate_phases(max int, mag int, base i64) []i64 {
  if mag >= max {
    return [base]
  }
  mut phases := []i64
  for i in 1..6 {
    if imath.has_digit(base, i) { continue }
    next := imath.pow(10, mag) * i + base
    extracted := generate_phases(max, mag + 1, next)
    for phase in extracted {
      phases << phase
    }
  }
  return phases
}

fn create_rig(mem []i64) []intcode.IntMachine {
  rig := [intcode.new(mem)].repeat(5)
  return rig
}

pub fn day07() {
  f := os.read_file('input/input07') or { panic(err) }
  code_strs := f.split(',')
  mem := code_strs.map(it.i64())

  phases := generate_phases(5, 0, 0) // 12345, not 01234

  mut best := i64(0)
  for phase in phases {
    mut out := i64(0)
    mut rig := create_rig(mem)
    for i in 0..5 {
      mut machine := rig[0]
      machine.feed(imath.nth_digit(phase - 11111, i))
      machine.run() or { panic(err) }
      machine.feed(out)
      result := machine.run() or { panic(err) }
      out = result.value
    }
    if out > best { best = out }
  }
  print('\t${best.str()}')

  best = 0
  for phase in phases {
    mut rig := create_rig(mem)

    // Consume phase settings
    for i in 0..rig.len {
      rig[i].feed(imath.nth_digit(phase + 44444, i))
      rig[i].run() or { panic(err) }
    }

    // Cycle signal until program is done
    mut out := i64(0)
    for idx := 0; ; idx = (idx + 1) % rig.len {
      rig[idx].feed(out)
      result := rig[idx].run() or { panic(err) }
      match result.state {
        .yield {
          out = result.value
          if idx == (rig.len - 1) && out > best { best = out }
        }
        .done { break }
        else {
          println(result)
          panic('program is still awaiting input (ph$phase @$idx)')
        }
      }
    }
  }
  print('\t${best}')
}

// Pitfalls today:

// Not sure how you're supposed to mutate during a loop
// for entry in entries -> Non-mutable reference
// for i in entries.len { mut entry := entries[i] -> Copy, won't mutate original
// for i in entries.leng { entries[i].do_mutation() -> only way found
// Not the most ergonomic, but can't deny it's explicit
