module advent
import os
import dim2

pub fn day10() {
  lines := os.read_lines('input/input10') or { panic(err) }
  width := lines[0].len
  height := lines.len
  mut grid := [`.`].repeat(width * height)

  for j, line in lines {
    for i, c in line.split('') {
      if c != '#' { continue }
      idx := i + j * width
      grid[idx] = `#`
    }
  }

  mut best := 0
  mut best_idx := -1
  for idx_a, a in grid {
    if a != `#` { continue }
    mut seen := 0
    pos_a := dim2.Vec {
      x: idx_a % width
      y: idx_a / width
    }
    for idx_b, b in grid {
      if b != `#` || idx_a == idx_b { continue }
      pos_b := dim2.Vec {
        x: idx_b % width
        y: idx_b / width
      }

      unit := (pos_b - pos_a).factorized()
      $if debug {
        println("a: $pos_a b: $pos_b unit: $unit")
      }
      mut blocked := false
      for pos := pos_a + unit; !pos.eq(pos_b); pos = pos + unit {
        idx_c := pos.x + pos.y * width
        if grid[idx_c] == `#` {
          blocked = true
          break
        }
      }
      if !blocked { seen++ }
      $if debug {
        if !blocked { println('seen: $pos_b') }
      }
    }
    if seen > best {
      best = seen
      best_idx = idx_a
    }
  }

  println(best)
}
