module advent

import os
import intcode
import dim2
import grid
import time

fn paint_program(mem []i64, dry_run bool) int {
	mut tiles := map[string]int
	pretty := '-pretty' in os.args
	if pretty {
		println('')
	}
	if !dry_run {
		tiles['0,0'] = 1
	}
	mut machine := intcode.new(mem)
	mut pos := dim2.Vec{
		0,0}
	mut dir := dim2.Vec{
		0,-1}
	mut painted := []dim2.Vec
	turn_dirs := [`L`, `R`]
	mut min := dim2.vec(0, 0)
	mut max := dim2.vec(0, 0)
	mut painting := grid.empty([' ', '.', '█', '@'])
	mut cycle := 0
	cycle_n := if dry_run { 256 } else { 4 }
	for {
		key := pos.key()
		machine.feed(i64(tiles[key]))
		paint_code := machine.run() or {
			panic(err)
		}
		if paint_code.state == .done {
			break
		}
		if !(key in tiles) {
			painted << pos
		}
		tiles[key] = int(paint_code.value + 1)
		if pos.x < min.x {
			min.x = pos.x
		}
		if pos.y < min.y {
			min.y = pos.y
		}
		if pos.x > max.x {
			max.x = pos.x
		}
		if pos.y > max.y {
			max.y = pos.y
		}
		if pretty && cycle % cycle_n == 0 {
			size := max - min + dim2.vec(1, 1)
			painting.read_map(tiles, size, min)
			idx := painting.idx_at_pos(pos - min)
			painting.data[idx] = 3
			print(painting.and_return(0))
			if !dry_run {
				time.sleep_ms(30)
			}
		}
		turn_code := machine.run() or {
			panic(err)
		}
		if turn_code.state == .done {
			break
		}
		turn_dir := turn_dirs[int(turn_code.value)]
		dir = dir.turn(turn_dir)
		pos = pos + dir
		cycle++
	}
	if pretty {
		print(painting.pass(0))
	}
	if !dry_run {
		size := max - min + dim2.vec(1, 1)
		painting.read_map(tiles, size, min)
		painting.collapse([1, 2])
		print('\t${painting.text()}')
	}
	return painted.len
}

pub fn day11() {
	f := os.read_file('input/input11') or {
		panic(err)
	}
	mem_str := f.split(',')
	mem := mem_str.map(it.i64())
	print('\t${paint_program(mem, true)}')
	paint_program(mem, false)
}
