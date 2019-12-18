module advent
import os
import intcode
import grid
import dim2

pub fn read_ascii_feed(machine mut intcode.IntMachine, feed mut grid.Grid) {
  mut idx := 0
  for {
    result := machine.run() or { panic(err) }
    if result.state == .yield {
      value := match byte(result.value) {
        `.` { 1 }
        `#` { 2 }
        `^` { 3 }
        `>` { 4 }
        `v` { 5 }
        `<` { 6 }
        `X` { 7 }
        `\n` { 10 }
        else { 0 }
      }
      if value == 0 {
        char := byte(result.value).str()
        println('Unrecognized value: $result.value ($char)')
      } else if value < 10 {
        feed.data[idx++] = value
      }
    } else {
      break
    }
  }
}

pub fn day17() {
  pretty := '-pretty' in os.args
  f := os.read_file('input/input17') or { panic(err) }
  mem_str := f.split(',')
  mem := mem_str.map(it.i64())

  mut machine := intcode.new(mem)
  mut grid_data := []int
  mut count := 0
  mut width := 0
  mut height := 0
  mut x := 0
  for {
    result := machine.run() or { panic(err) }
    if result.state != .yield {
      break
    } else if result.value == 10 {
      if x > width { width = x }
      height++
      x = 0
      continue
    } else {
      x++
    }
  }
  mut feed := grid.new([0].repeat(width * height), width, [
    ' ', '.', '#', '^', '>', 'v', '<', 'X', 'O'
  ])
  machine = intcode.new(mem)
  read_ascii_feed(mut machine, mut feed)
  cardinals := [
    dim2.vec(0, -1),
    dim2.vec(1, 0),
    dim2.vec(0, 1),
    dim2.vec(-1, 0),
  ]
  mut align_sum := 0
  for y in 1..(feed.height - 1) {
    for x in 1..(feed.width - 1) {
      idx := x + y * feed.width
      if feed.data[idx] < 2 { continue }
      mut is_inter := true
      for i in [idx - 1, idx - feed.width, idx + 1, idx + feed.width] {
        if feed.data[i] >= 2 { continue }
        is_inter = false
        break
      }
      if is_inter {
        align_sum += x * y
        if pretty { feed.data[idx] = 8 }
      }
    }
  }
  if pretty {
    println('')
    println(feed)
  }
  print('\t$align_sum')

  machine = intcode.new(mem)
  machine.mem[0] = 2
}
