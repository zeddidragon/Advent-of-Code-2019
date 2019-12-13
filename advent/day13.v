module advent
import os
import intcode
import grid
import imath

fn draw_game(mem []i64, interactive bool) int {
  mut tiles := map[string]byte
  mut machine := intcode.new(mem)
  mut max_x := 0
  mut max_y := 0

  mut blocks := 0
  mut score := 0
  mut ball_x := 0
  mut paddle_x := 0
  for{
    blocks = 0
    for {
      mut code := machine.take(3) or { break }
      x := int(code[0])
      y := int(code[1])
      tile := int(code[2])
      if x > max_x { max_x = x }
      if y > max_y { max_y = y }
      if x == -1 && y == 0 {
        score = tile
      } else {
        match tile {
          3 { paddle_x = x }
          4 { ball_x = x }
        }
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
          if tile == `#` { blocks++ }
          grid_data[idx] = tile
        }
        idx++
      }
    }

    if interactive {
      $if debug {
        println(score)
        println(grid.new(grid_data, width))
      }
      if blocks == 0 { return score }
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

  println(draw_game(mem, false))
  mem[0] = 2
  println(draw_game(mem, true))
}
