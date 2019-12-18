module advent
import os
import intcode
import grid
import imath
import dim2

fn draw_game(mem []i64, destroy_blocks int) int {
  mut tiles := map[string]int
  mut machine := intcode.new(mem)
  mut size := dim2.vec(1, 1)

  mut blocks := imath.max(0, destroy_blocks)
  mut score := 0
  mut ball_x := 0
  mut paddle_x := 0
  zero := dim2.vec(0, 0)

  mut screen := grid.empty(['.', '█', '#', '=', 'o'])
  mut step := 0

  pretty := '-pretty' in os.args
  for{
    for {
      code := machine.take(3) or { break }
      x := int(code[0])
      y := int(code[1])
      tile := int(code[2])
      if x + 1 > size.x { size.x = x + 1 }
      if y + 1 > size.y { size.y = y + 1 }
      if x == -1 && y == 0 {
        score = tile
        blocks--
      } else {
        match tile {
          2 { if destroy_blocks == -1 { blocks++ } }
          3 { paddle_x = x }
          4 { ball_x = x }
          else { }
        }
        if pretty { tiles['$x,$y'] = tile }
      }
    }

    if pretty && (step++ % 8 == 0 || blocks < 0) {
      screen.read_map(tiles, size, zero)
      print('\n$score\n${screen.and_return(2)}')
    }

    if destroy_blocks >= 0 {
      // Have to count 1 extra for some reason??
      if blocks < 0 {
        if pretty { println('\n'.repeat(size.y + 1)) }
        return score
      }
      machine.feed(imath.sign(ball_x - paddle_x))
    } else {
      return blocks
    }
  }
  return 0 // Appease compiler
}

pub fn day13() {
  f := os.read_file('input/input13') or { panic(err) }
  mem_str := f.split(',')
  mut mem := mem_str.map(it.i64())

  blocks := draw_game(mem, -1)
  print('\t${blocks}')
  mem[0] = 2
  print('\t${draw_game(mem, blocks)}')
}

// Pitfalls today:
// 20:19:57 ❯ ./run -pretty
// advent/day13.v:47:0: 0 character in a string literal
//   45|         '.', '█', '#', '=', 'o',
// Can't do terminal control characters :[
