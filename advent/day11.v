module advent
import os
import intcode
import dim2
import grid

fn paint_program(mem []i64, dry_run bool) int {
  mut tiles := map[string]int
  if !dry_run {
    tiles['0,0'] = 1
  }
  mut machine := intcode.new(mem)
  mut pos := dim2.Vec {0, 0}
  mut dir := dim2.Vec {0, -1}
  mut painted := []dim2.Vec
  turn_dirs := [`L`, `R`]
  for {
    key := pos.key()
    machine.feed(i64(tiles[key]))

    paint_code := machine.run() or { panic(err) }
    if paint_code.state == .done { break }
    if !(key in tiles) { painted << pos }
    tiles[key] = int(paint_code.value)

    turn_code := machine.run() or { panic(err) }
    if turn_code.state == .done { break }
    turn_dir := turn_dirs[int(turn_code.value)]
    dir = dir.turn(turn_dir)
    pos = pos + dir
  }

  mut min_x := 0
  mut min_y := 0
  mut max_x := 0
  mut max_y := 0
  for p in painted {
    if p.x < min_x { min_x = p.x }
    if p.y < min_y { min_y = p.y }
    if p.x > max_x { max_x = p.x }
    if p.y > max_y { max_y = p.y }
  }

  if !dry_run {
    width := max_x - min_x + 1
    height := max_y - min_y + 1
    mut grid_data := [0].repeat(width * height)
    mut idx := 0
    for y in min_y..(max_y + 1) {
      for x in min_x..(max_x + 1) {
        tile := tiles['$x,$y']
        if tile > 0 { grid_data[idx] = tile }
        idx++
      }
    }
    println(grid.new(grid_data, width, ['.', '█']))
  }

  return painted.len
}

pub fn day11() {
  f := os.read_file('input/input11') or { panic(err) }
  mem_str := f.split(',')
  mem := mem_str.map(it.i64())

  println(paint_program(mem, true))
  paint_program(mem, false)
}
