module advent
import os
import intcode
import dim2
import grid
import time

fn paint_program(mem []i64, dry_run bool) int {
  mut tiles := map[string]int
  pretty := '-pretty' in os.args
  if pretty && !dry_run { println('') }
  if !dry_run {
    tiles['0,0'] = 1
  }
  mut machine := intcode.new(mem)
  mut pos := dim2.Vec {0, 0}
  mut dir := dim2.Vec {0, -1}
  mut painted := []dim2.Vec
  turn_dirs := [`L`, `R`]
  mut min_x := 0
  mut min_y := 0
  mut max_x := 0
  mut max_y := 0
  mut painting := grid.empty(['.', '█', '@'])
  for {
    key := pos.key()
    machine.feed(i64(tiles[key]))

    paint_code := machine.run() or { panic(err) }
    if paint_code.state == .done { break }
    if !(key in tiles) { painted << pos }
    tiles[key] = int(paint_code.value)
    if pos.x < min_x { min_x = pos.x }
    if pos.y < min_y { min_y = pos.y }
    if pos.x > max_x { max_x = pos.x }
    if pos.y > max_y { max_y = pos.y }

    if pretty && !dry_run{
      width := max_x - min_x + 1
      height := max_y - min_y + 1
      painting.read_map(tiles, width, height)
      idx := painting.idx_at_pos(pos - dim2.Vec { min_x, min_y })
      painting.data[idx] = 2
      print(painting.and_return(0))
      time.sleep_ms(30)
    }

    turn_code := machine.run() or { panic(err) }
    if turn_code.state == .done { break }
    turn_dir := turn_dirs[int(turn_code.value)]
    dir = dir.turn(turn_dir)
    pos = pos + dir
  }

  if !dry_run {
    width := max_x - min_x + 1
    height := max_y - min_y + 1
    painting.read_map(tiles, width, height)
    if pretty { print(painting.pass(0)) }
    print('\t${painting.text()}')
  }

  return painted.len
}

pub fn day11() {
  f := os.read_file('input/input11') or { panic(err) }
  mem_str := f.split(',')
  mem := mem_str.map(it.i64())

  print('\t${paint_program(mem, true)}')
  paint_program(mem, false)
}
