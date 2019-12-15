module advent
import os
import intcode
import grid
import dim2
import time

fn move_command(vec dim2.Vec) i64 {
  if vec.y < 0 { return 1 }
  if vec.y > 0 { return 2 }
  if vec.x < 0 { return 3 }
  if vec.x > 0 { return 4 }
  println('Dir vec is null vector?')
  return 0
}

fn navigate_maze(mem []i64) int {
  pretty := '-pretty' in os.args
  if pretty { println('') }
  mut tiles := map[string]int
  mut step_map := map[string]int
  mut machine := intcode.new(mem)
  mut maze := grid.empty([' ', '.', '█', 'O', '@', 'X'])

  start := dim2.vec(0, 0)
  mut pos := start.copy()
  mut dir := dim2.vec(0, -1)
  tiles[pos.key()] = 1
  step_map[pos.key()] = 0

  mut min_x := 0
  mut min_y := 0
  mut max_x := 0
  mut max_y := 0

  mut done := false
  mut steps := 0

  for !done {
    cmd := move_command(dir)
    machine.feed(cmd)
    tile := machine.run() or { panic(err) }
    tile_pos := pos + dir

    // println('pos: $pos dir: $dir cmd: $cmd tile: $tile.value')

    if tile_pos.x < min_x { min_x = tile_pos.x }
    if tile_pos.x > max_x { max_x = tile_pos.x }
    if tile_pos.y < min_y { min_y = tile_pos.y }
    if tile_pos.y > max_y { max_y = tile_pos.y }

    key := tile_pos.key()
    match tile.value {
      0 {
        tiles[key] = 2
        dir = dir.turn(`L`)
      }
      1 {
        steps++
        pos = tile_pos
        if key in tiles {
          steps = step_map[key]
        } else {
          tiles[key] = 1
          step_map[key] = steps
        }
        right := pos + dir.turn(`R`)
        if tiles[right.key()] < 2 { dir = dir.turn(`R`) }
      }
      2 {
        tiles[key] = 3
        steps++
        done = true
      }
      else {
        println('Unknown status code: $tile.value')
      }
    }

    if pretty {
      maze.read_map(tiles, max_x - min_x + 1, max_y - min_y + 1, min_x, min_y)
      offset := dim2.vec(min_x, min_y)
      maze.data[maze.idx_at_pos(pos - offset)] = 4
      maze.data[maze.idx_at_pos(start - offset)] = 5
      println(maze.and_return(1))
      time.sleep_ms(8)
    }
  }
  if pretty { println(maze.pass(1)) }
  return steps
}

pub fn day15() {
  f := os.read_file('input/input15') or { panic(err) }
  mem_str := f.split(',')
  mem := mem_str.map(it.i64())
  steps := navigate_maze(mem)
  print('\t$steps')
}
