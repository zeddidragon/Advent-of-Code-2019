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

struct RobotMaze {
  mut:
    machine intcode.IntMachine
    tiles map[string]int
    step_map map[string]int
    steps int
    pos dim2.Vec
    dir dim2.Vec
    min dim2.Vec
    max dim2.Vec
}

fn new_robot_maze(mem []i64) RobotMaze {
  mut tiles := map[string]int
  mut step_map := map[string]int
  pos := dim2.vec(0, 0)
  start := pos.key()
  tiles[start] = 1
  step_map[start] = 0

  return RobotMaze {
    machine: intcode.new(mem)
    tiles: tiles
    step_map: step_map
    pos: pos
    dir: dim2.vec(0, -1)
    min: dim2.vec(0, 0)
    max: dim2.vec(0, 0)
  }
}

fn (robo mut RobotMaze) navigate_maze(keep_going bool) int {
  pretty := '-pretty' in os.args
  if pretty { println('') }
  mut maze := grid.empty([' ', '.', '█', 'O', '@', 'X'])
  start := dim2.vec(0, 0)
  mut done := false

  for !done {
    cmd := move_command(robo.dir)
    robo.machine.feed(cmd)
    tile := robo.machine.run() or { panic(err) }
    tile_pos := robo.pos + robo.dir

    // println('pos: $pos dir: $dir cmd: $cmd tile: $tile.value')

    if tile_pos.x < robo.min.x { robo.min.x = tile_pos.x }
    if tile_pos.x > robo.max.x { robo.max.x = tile_pos.x }
    if tile_pos.y < robo.min.y { robo.min.y = tile_pos.y }
    if tile_pos.y > robo.max.y { robo.max.y = tile_pos.y }

    key := tile_pos.key()
    match tile.value {
      0 {
        robo.tiles[key] = 2
        robo.dir = robo.dir.turn(`L`)
      }
      1 {
        robo.steps++
        robo.pos = tile_pos
        if key in robo.tiles {
          robo.steps = robo.step_map[key]
        } else {
          robo.tiles[key] = 1
          robo.step_map[key] = robo.steps
        }
        right := robo.pos + robo.dir.turn(`R`)
        if robo.tiles[right.key()] != 3 { robo.dir = robo.dir.turn(`R`) }
        // Hit the start again, done exploring
        if robo.pos.x == 0 && robo.pos.y == 0 { done = true }
      }
      2 {
        robo.tiles[key] = 3
        robo.steps++
        robo.pos = tile_pos
        if !keep_going {
          done = true
        }
      }
      else {
        println('Unknown status code: $tile.value')
      }
    }

    if pretty && (robo.steps % 12 == 0 || done) {
      maze.read_map(robo.tiles, robo.max - robo.min + dim2.vec(1, 1), robo.min)
      maze.data[maze.idx_at_pos(start - robo.min)] = 5
      maze.data[maze.idx_at_pos(robo.pos - robo.min)] = 4
      println(maze.and_return(1))
      // if !keep_going { time.sleep_ms(8) }
    }
  }
  if pretty { println('\n'.repeat(robo.max.y - robo.min.y + 2)) }
  return robo.steps
}

pub fn day15() {
  f := os.read_file('input/input15') or { panic(err) }
  mem_str := f.split(',')
  mem := mem_str.map(it.i64())
  mut robo := new_robot_maze(mem)
  steps := robo.navigate_maze(false)
  print('\t$steps')
  robo.navigate_maze(true)
}
