module advent
import os
import grid
import array


const (
  int_max = 2147483647
)

struct KeyDistance {
  mut:
    pos int
    from byte
    to byte
    doors []byte
    steps int
}

fn (kd KeyDistance) clone() KeyDistance {
  return KeyDistance {
    pos: kd.pos
    from: kd.from
    to: kd.from
    doors: array.byte_clone(kd.doors)
    steps: kd.steps
  }
}

fn (kd mut KeyDistance) lock(key byte) {
  if key in kd.doors { return }
  kd.doors << key
}

pub fn (kd KeyDistance) str() string {
  mut ret := '${kd.from.str()} ='
  for door in kd.doors {
    ret += '|${door.str()}'
  }
  if kd.doors.len > 0 {
    ret += '|'
  }

  return '$ret> ${kd.to.str()} ($kd.steps)'
}

struct DungeonCrawl {
  mut:
    paths []KeyDistance
    at byte
    unlocked []byte
    terminals []byte
    steps int
    failed bool
}

fn (crawl mut DungeonCrawl) move(key byte) {
  for path in crawl.paths {
    if path.from == crawl.at && path.to == key {
      crawl.unlocked << [key, key - 0x20]
      crawl.at = key
      crawl.steps += path.steps
      return
    }
  }
}

fn (crawl DungeonCrawl) check(key byte) DungeonCrawl {
  mut new_crawl := DungeonCrawl {
    paths: crawl.paths
    at: crawl.at
    unlocked: array.byte_clone(crawl.unlocked)
    terminals: array.byte_clone(crawl.terminals)
    steps: crawl.steps
    failed: false
  }

  fr := new_crawl.at.str()
  to := key.str()
  mut unlocked_later := []byte
  for path in new_crawl.paths {
    if path.from != new_crawl.at || path.to != key { continue }
    for door in path.doors {
      if door in new_crawl.unlocked { continue }
      if door in new_crawl.terminals {
        new_crawl.failed = true
        new_crawl.steps = int_max
        return new_crawl
      }
      if door >= `a` && door <= `z` {
        unlocked_later << door
      } else {
        new_crawl = new_crawl.check(door + 0x20)
        return new_crawl.check(key)
      }
    }

    idx := new_crawl.terminals.index(key)
    if idx >= 0 { new_crawl.terminals.delete(idx) }
    new_crawl.unlocked << [key, key - 0x20]
    new_crawl.steps += path.steps
    new_crawl.at = key
    return new_crawl
  }

  for key in unlocked_later {
    if !key in new_crawl.unlocked {
      new_crawl.unlocked << key
    }
  }

  new_crawl.failed = true
  return new_crawl
}

fn (crawl DungeonCrawl) best_crawl() DungeonCrawl {
  mut best := DungeonCrawl { steps: int_max }
  if crawl.failed { return best }
  if crawl.terminals.len == 0 { return crawl }

  for t in crawl.terminals {
    mut iter := crawl.check(t)
    if iter.failed { continue }
    iter = iter.best_crawl()
    if iter.steps < best.steps { best = iter }
  }
  return best
}

fn dungeon_key_distances(dungeon grid.Grid, key byte) []KeyDistance {
  mut distances := []KeyDistance
  mut dng := dungeon.clone()
  pos := dng.data.index(int(key))
  dng.data[pos] = 1
  mut explored := [KeyDistance {
    pos: pos
    from: key
  }]

  for explored.len > 0 {
    mut new_explored := []KeyDistance
    for ex in explored {
      idx := ex.pos
      for n_idx in [idx - dng.width, idx - 1, idx + 1, idx + dng.width] {
        c := byte(dng.data[n_idx])
        if c == 1 { continue }
        mut new_kd := ex.clone()
        new_kd.pos = n_idx
        new_kd.steps++
        if c >= `A` && c <= `Z` {
          new_kd.lock(c)
        }
        if c >= `a` && c <= `z` {
          mut to_kd := new_kd.clone()
          to_kd.to = c
          distances << to_kd
          new_kd.lock(c)
        }
        new_explored << new_kd
        dng.data[n_idx] = 1
      }
    }
    explored = new_explored
  }
  return distances
}

fn fastest_dungeon_crawl(dungeon grid.Grid) DungeonCrawl {
  mut keys := []byte
  for c in dungeon.data {
    char := byte(c)
    if char >= `a` && char <= `z` {
      keys << char
    }
  }

  mut paths := dungeon_key_distances(dungeon, `@`)
  mut terminals := keys.clone()
  for path in paths {
    for door in path.doors {
      key_idx := terminals.index(door)
      if key_idx >= 0 { terminals.delete(key_idx) }
    }
  }
  for key in keys {
    paths << dungeon_key_distances(dungeon, key)
  }

  crawl := DungeonCrawl {
    paths: paths
    at: `@`
    terminals: terminals
  }

  return crawl.best_crawl()
}

fn run_day18(filename string) int {
  f := os.read_lines(filename) or { panic(err) }
  mut dungeon := grid.from_lines(f, ['.', '#'])

  best := fastest_dungeon_crawl(dungeon)
  println('\t$best.steps')
  mut from := `@`
  mut total := 0
  for door in best.unlocked {
    for path in best.paths {
      if path.from == from && path.to == door {
        println('${from.str()} => ${door.str()} ($path.steps)')
        from = door
        total += path.steps
        break
      }
    }
  }

  return total
}

pub fn day18() {
  println(run_day18('input/input18-test1'))
  println('Expected: 8')
  println(run_day18('input/input18-test2'))
  println('Expected: 86')
  println(run_day18('input/input18-test3'))
  println('Expected: 132')
  println(run_day18('input/input18-test4'))
  println('Expected: 136')
  println(run_day18('input/input18-test5'))
  println('Expected: 81')
}
