module advent
import os
import grid


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

fn (kd KeyDistance) clone() KeyDistance {
  return KeyDistance {
    pos: kd.pos,
    from: kd.from,
    to: kd.to,
    doors: kd.doors.clone(),
    steps: kd.steps,
  }
}

fn (kd mut KeyDistance) unlock(key byte) {
  door_idx := kd.doors.index(key - 32)
  if door_idx >= 0 { kd.doors.delete(door_idx) }
}

fn (kd mut KeyDistance) lock(door byte) {
  if door in kd.doors { return }
  kd.doors << door
}

struct MazePath {
  steps int
  from byte
  options []KeyDistance
}

pub fn (kd MazePath) str() string {
  return 'from ${kd.from.str()} ($kd.steps)'
}

fn options_for_key(kds []KeyDistance, key byte, steps int) []MazePath {
  mut ret := []MazePath
  mut froms := []KeyDistance
  mut new_kds := []KeyDistance
  for kd in kds {
    mut new_kd := kd.clone()
    new_kd.unlock(key)
    if new_kd.from == key && new_kd.doors.len == 0 {
      froms << new_kd
    } else if new_kd.from != key {
      new_kds << new_kd
    }
  }

  for from in froms {
    ret << MazePath {
      steps: steps + from.steps
      from: from.to
      options: new_kds
    }
  }
  return ret
}

fn sort_options(paths mut []MazePath) {
  if paths.len < 1 { return }

  // Bubble sort, not optimal at all
  mut sorted := false
  for !sorted {
    sorted = true
    for i, a in paths[1..] {
      b := paths[i] // i for first element is 0
      if a.steps < b.steps {
        sorted = false
        paths[i] = a
        paths[i + 1] = b
      }
    }
  }
}

fn fastest_crawl(kds []KeyDistance) int {
  mut options := options_for_key(kds, `@`, 0)
  for {
    sort_options(mut options)
    println(options)
    choice := options.first()
    if choice.options.len == 0 { return choice.steps }
    options.delete(0)
    options << options_for_key(choice.options, choice.from, choice.steps)
  }
  return 0
}

fn fastest_dungeon_crawl(dungeon grid.Grid) int {
  mut keys := [`@`]
  for c in dungeon.data {
    char := byte(c)
    if char >= `a` && char <= `z` {
      keys << char
    }
  }

  mut key_distances := []KeyDistance
  for key in keys {
    mut dng := dungeon.clone()
    pos := dng.data.index(int(key))
    dng.data[pos] = 1
    mut explored := [KeyDistance {
      pos: pos
      from: key
      to: 0
      doors: []
      steps: 0
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
            key_distances << new_kd
            new_kd = new_kd.clone()
            new_kd.lock(c - 32)
          }
          new_explored << new_kd
          dng.data[n_idx] = 1
        }
      }
      explored = new_explored
    }
  }

  println('')
  println(keys)
  return 0
  // return fastest_crawl(key_distances)
}

pub fn day18() {
  f := os.read_lines('input/input18-test') or { panic(err) }
  mut dungeon := grid.from_lines(f, ['.', '#'])

  println('')
  best := fastest_dungeon_crawl(dungeon)
  println('\t$best')
}
