module advent

import os


struct IdTag {
  id int
  line Line2
}

fn day03() {
  day(3, 1)
  f := os.read_file('input/input03') or {
    println('input03 not found!')
    return
  }

  wires := f.split('\n')

  mut grid := map[string]int
  mut lines := []IdTag
  mut inters := []Vec2

  for j, wire in wires {
    id := j + 1
    mut pos := Vec2{0, 0}

    for move in wire.split(',') {
      prev := pos.copy()
      pos.move(move[0], move[1..].int())
      l1 := Line2 {prev, pos.copy()}
      for l2 in lines {
        if id == l2.id { continue }
        inter := l1.inter(l2.line) or { continue }
        inters << inter
      }
      lines << IdTag {id, l1}
    }

  }

  mut shortest := inters[1].manhattan()
  for inter in inters[1..] {
    dist := inter.manhattan()
    if dist < shortest {
      shortest = dist
    }
  }

  println(shortest)
}
