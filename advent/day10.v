module advent
import os
import dim2
import grid

struct VisibleAsteroidsResult {
  count int
  data []dim2.Vec
}

fn visible_asteroids(grid grid.Grid, idx_a int, count bool)
VisibleAsteroidsResult {
  mut seen_count := 0
  mut seen := []dim2.Vec
  pos_a := dim2.Vec {
    x: idx_a % grid.width
    y: idx_a / grid.width
  }
  for idx_b, b in grid.data {
    if b != `#` || idx_a == idx_b { continue }
    pos_b := dim2.Vec {
      x: idx_b % grid.width
      y: idx_b / grid.width
    }

    b_diff := pos_b - pos_a
    unit := b_diff.factorized()
    $if debug {
      println("a: $pos_a b: $pos_b unit: $unit")
    }
    mut blocked := false
    for pos := pos_a + unit; !pos.eq(pos_b); pos = pos + unit {
      idx_c := pos.x + pos.y * grid.width
      if grid.data[idx_c] == `#` {
        blocked = true
        break
      }
    }
    if !blocked {
      seen_count++
      if !count {
        seen << pos_b
        angle := b_diff.angle()
        for i, pos_c in seen {
          c_diff := pos_c - pos_a
          if c_diff.angle() > angle {
            mut shift := pos_c
            for j, next in seen[(i + 1)..] {
              seen[j] = shift
              shift = next
            }
            seen[i] = shift
          }
        }
      }
      $if debug { println('seen: $pos_b') }
    }
  }
  return VisibleAsteroidsResult {
    count: seen_count
    data: seen
  }
}

pub fn day10() {
  lines := os.read_lines('input/input10') or { panic(err) }
  grid := grid.from_lines(lines)

  mut best := 0
  mut best_idx := -1
  for idx, c in grid.data {
    if c != `#` { continue }
    seen := visible_asteroids(grid, idx, true).count
    if seen > best {
      best = seen
      best_idx = idx
    }
  }

  println(best)
}


// Pitfalls today:
// It's not yet possible to expand arrays passed in functions
// Opted to insert element first, then make a function that assumes
// the last element needs sorting.

// Got some kinda of c error where V passed by reference but called functions
// as if direct value. Had to keep sorting in the loop code.
