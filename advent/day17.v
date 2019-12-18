module advent
import os
import intcode
import grid
import dim2
import array

fn read_ascii_feed(machine mut intcode.IntMachine, feed mut grid.Grid) {
  mut idx := 0
  mut skip := 0
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
        print(char)
        // println('Unrecognized value: $result.value ($char) @$idx')
      } else if value < 10 {
        if skip > 0 { skip = 0 }
        feed.data[idx++] = value
      } else {
        skip++
        if skip > 1 {
          return
        }
      }
    } else {
      break
    }
  }
}

fn feed_ascii(m mut intcode.IntMachine, input string) {
  for n in input {
    m.feed(i64(n))
    for {
      result := m.run() or { panic(err) }
      if result.state == .await { break }
    }
  }
}

fn print_ascii_moves(moves []int) {
  for move in moves {
    if move == -1 {
      print('L,')
    } else if move == -2 {
      print('R,')
    } else {
      print('$move,')
    }
  }
  println('')
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
  mut robo := dim2.vec(-1, -1)
  mut robo_dir := dim2.vec(0, -1)
  for {
    result := machine.run() or { panic(err) }
    if result.state != .yield {
      break
    } else if result.value == 10 {
      if x > width { width = x }
      height++
      x = 0
      continue
    } else if result.value in [`^`, `>`, `v`, `<`] {
      robo.x = x
      robo.y = height
      robo_dir = match result.value {
        `^` { dim2.vec(0, -1) }
        `>` { dim2.vec(1, 0) }
        `v` { dim2.vec(0, 1) }
        `<` { dim2.vec(-1, 0) }
        else { robo_dir } // Appease compiler, obviously can't happen
      }
    }
    x++
  }
  mut feed := grid.new([0].repeat(width * height), width, [
    ' ', '.', '#', '^', '>', 'v', '<', 'X', 'O', '█',
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

  // From looking at the output, the path simple consists following the path
  // and spiraling along the catwalk until you reach the end.
  // Naively, the puzzle can be solved by simple following each catwalk
  // to the end and only turning when needed

  // For this solution, I'm making two assumptions
  // 1. The puzzle can be solved by making the only available turn
  //    at the end of any given path.
  // 2. This holds true for all inputs.

  // First, find the path:

  robo_turn_left := -1
  robo_turn_right := -2
  floor := 2
  mut moves := []int
  mut steps := 0
  for {
    floor_ahead := feed.tile_at_pos(robo + robo_dir) >= floor
    if !floor_ahead && steps > 0 { steps = 0 }

    if steps > 0 && floor_ahead {
      moves[moves.len - 1]++
      steps++
    } else if floor_ahead {
      moves << 1
      steps = 1
    }

    if steps > 0 {
      robo = robo + robo_dir
      feed.data[feed.idx_at_pos(robo)] = 100 + steps
      continue
    }

    left := robo_dir.turn(`L`)
    if feed.tile_at_pos(robo + left) >= floor {
      moves << robo_turn_left
      robo_dir = left
      continue
    }

    right := robo_dir.turn(`R`)
    if feed.tile_at_pos(robo + right) >= floor {
      moves << robo_turn_right
      robo_dir = right
      continue
    }

    break
  }

  if pretty {
    println('')
    println(feed)
  }

  // This is obviously very specific to my input
  a := 'R,12,L,8,R,12\n'
  b := 'R,8,R,6,R,6,R,8\n'
  c := 'R,8,L,8,R,8,R,4,R,4\n'
  main := 'A,B,A,B,C,C,B,C,B,A\n'

  if pretty {
    print_ascii_moves(moves)
    print('A: $a')
    print('B: $b')
    print('C: $c')
  }

  machine = intcode.new(mem)
  machine.mem[0] = 2
  feed_ascii(mut machine, main)
  feed_ascii(mut machine, a)
  feed_ascii(mut machine, b)
  feed_ascii(mut machine, c)
  if pretty {
    feed_ascii(mut machine, 'y')
  } else {
    feed_ascii(mut machine, 'n')
  }

  machine.feed(i64(`\n`))
  for {
    if pretty {
      read_ascii_feed(mut machine, mut feed)
      print(feed.and_return(0))
    }
    result := machine.run() or { panic(err )}
    if result.value > 200 {
      print(feed.pass(0))
      println('\t$result.value')
      break
    }
    if result.state == .done { break }
  }
}
