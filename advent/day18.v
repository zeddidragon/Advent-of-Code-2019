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
    terminal byte
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

  return '$ret> ${kd.to.str()} ($kd.steps) |${kd.terminal.str()}'
}

fn find_key_distance(paths []KeyDistance, from byte, to byte) ?KeyDistance {
  for path in paths {
    if path.from == from && path.to == to { return path }
  }
  return error('path not found')
}

struct DungeonCrawl {
  mut:
    paths []KeyDistance
    at byte
    unlocked []byte
    steps int
    failed bool
}

fn (dc DungeonCrawl) clone() DungeonCrawl {
  paths := dc.paths
  cloned := paths.map(it)
  return DungeonCrawl {
    paths: cloned
    at: dc.at
    unlocked: array.byte_clone(dc.unlocked)
    steps: dc.steps
    failed: dc.failed
  }
}

fn (dc DungeonCrawl) best_crawl() DungeonCrawl {
  mut best := DungeonCrawl { steps: int_max, failed: true }
  mut viable := 0
  for path in dc.paths {
    if path.from != dc.at { continue }
    viable++

    mut failed := false
    for door in path.doors {
      if door < `A` || door > `Z` { continue }
      if door in dc.unlocked { continue }
      failed = true
      break
    }
    if failed { continue }

    mut crawl := dc.clone()
    for door in path.doors {
      if door < `a` || door > `z` { continue }
      if door in crawl.unlocked { continue }
      crawl.unlocked << [door, door - 0x20]
    }
    if path.terminal == path.to {
      paths := dc.paths
      pruned := paths.filter(it.terminal != path.terminal)
      crawl.paths = pruned
    }
    crawl.steps += path.steps
    crawl.at = path.to
    attempt := crawl.best_crawl()
    if !attempt.failed && attempt.steps <= best.steps { best = attempt }
  }
  return if viable == 0 { dc } else { best }
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
        if (c >= `a` && c <= `z`) || (c >= `A` && c <= `Z`) {
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

  mut starts := dungeon_key_distances(dungeon, `@`)
  mut terminals := []byte
  for c in dungeon.data {
    char := byte(c)
    if (char >= `a` && char <= `z`) || (char >= `A` && char <= `Z`) {
      terminals << char
    }
  }

  // First determine all possible paths in maze
  for i, path in starts {
    for door in path.doors {
      key_idx := terminals.index(door)
      if key_idx >= 0 { terminals.delete(key_idx) }
    }
    starts[i].doors << path.to
  }

  // Remove terminals that are just doors
  mut blacklisted := []byte
  mut i := 0
  for i < terminals.len {
    t := terminals[i]
    if t >= `a` && t <= `z` {
      i++
      continue
    }

    if !(t in blacklisted) {
      blacklisted << t
    }

    path := find_key_distance(starts, `@`, t) or { panic(err) }
    if path.doors.len < 2 {
      terminals.delete(i)
    } else {
      terminals[i] = path.doors[path.doors.len - 2]
    }
  }

  // Remove duplicates
  i = 0
  mut seen := []byte
  for i < terminals.len {
    t := terminals[i]
    if t in seen {
      terminals.delete(i)
    } else {
      seen << t
      i++
    }
  }

  // Remove terminals that aren't
  mut doors := []byte
  for t in terminals {
    path := find_key_distance(starts, `@`, t) or { panic(err) }
    doors << path.doors[..(path.doors.len - 1)]
  }
  i = 0
  for i < terminals.len {
    t := terminals[i]
    if t in doors {
      terminals.delete(i)
    } else {
      i++
    }
  }

  // Add all the nodes we need to consider
  // 1. The next node in the path from the current node (node is a key or door)
  // 2. The door unlocked by any given key
  // 3. The first key in all other paths from each path's terminal
  // This will lead to some duplicates, which is not a big deal
  mut paths := []KeyDistance
  for t in terminals {
    mut path := find_key_distance(starts, `@`, t) or { panic(err) }
    mut current := `@`
    mut nexts := starts
    for next in path.doors {
      // 1. Stride from node to next node in path
      mut to_next := find_key_distance(nexts, current, next) or { panic(err) }
      to_next.terminal = path.to
      nexts = dungeon_key_distances(dungeon, next)
      for i, n in nexts {
        nexts[i].doors << n.to
      }
      paths << to_next
      current = next
      if next >= `a` && next <= `z` {
        // 2. Path from key to door
        door := next - 0x20
        if door in blacklisted { continue }
        mut to_door := find_key_distance(nexts, next, door) or { continue }
        for start in starts {
          if door in start.doors { to_door.terminal = start.to }
        }
        paths << to_door
      }
    }

    // 3. The first key in all other paths from the path's terminal
    for t2 in terminals {
      if path.to == t2 { continue }
      t2_path := find_key_distance(starts, `@`, t2) or { panic(err) }
      start := t2_path.doors[0]
      mut t_to_start := find_key_distance(nexts, path.to, start) or {
        panic(err)
      }
      t_to_start.terminal = t2
      paths << t_to_start
    }
  }

  crawl := DungeonCrawl {
    paths: paths
    at: `@`
  }

  for path in paths {
    println(path)
  }
  return crawl//.best_crawl()
}

fn run_day18(filename string) int {
  f := os.read_lines(filename) or { panic(err) }
  mut dungeon := grid.from_lines(f, ['.', '#'])

  best := fastest_dungeon_crawl(dungeon)
  println(best.unlocked)
  return best.steps
}

pub fn day18() {
  // println(run_day18('input/input18-test1'))
  // println('Expected: 8')
  // println(run_day18('input/input18-test2'))
  // println('Expected: 86')
  // println(run_day18('input/input18-test3'))
  // println('Expected: 132')
  // println(run_day18('input/input18-test4'))
  // println('Expected: 136')
  // println(run_day18('input/input18-test5'))
  // println('Expected: 81')
  println(run_day18('input/input18'))
}
