module advent
import os
import intcode
import grid
import imath

fn draw_game(mem []i64, destroy_blocks int) int {
  mut tiles := map[string]byte
  mut machine := intcode.new(mem)
  mut max_x := 0
  mut max_y := 0

  mut blocks := imath.max(0, destroy_blocks)
  mut score := 0
  mut ball_x := 0
  mut paddle_x := 0
  for{
    for {
      mut code := machine.take(3) or { break }
      x := int(code[0])
      y := int(code[1])
      tile := int(code[2])
      if x > max_x { max_x = x }
      if y > max_y { max_y = y }
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
        $if debug {
          tiles['$x,$y'] = match tile {
            0 { `.` }
            1 { `M` }
            2 { `#` }
            3 { `_` }
            4 { `o` }
            else { `?` }
          }
        }
      }
    }

    $if debug {
      width := max_x + 1
      height := max_y + 1
      mut grid_data := [` `].repeat(width * height)
      mut idx := 0
      for y in 0..height {
        for x in 0..width {
          grid_data[idx]
          key := '$x,$y'
          if key in tiles {
            tile := tiles[key]
            grid_data[idx] = tile
          }
          idx++
        }
      }
      println('$score\n${grid.new(grid_data, width)}')
    }

    if destroy_blocks >= 0 {
      // Have to count 1 extra for some reason??
      if blocks < 0 { return score }
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
  println(blocks)
  mem[0] = 2
  println(draw_game(mem, blocks))
}
