module advent

import os
import grid

struct VisibleAsteroidsResult {
	count int
	data  []dim2.Vec
}

fn visible_asteroids(grid grid.Grid, idx_a int, count_only bool) VisibleAsteroidsResult {
	mut count := 0
	mut seen := []dim2.Vec
	pos_a := grid.pos_at_idx(idx_a)
	for idx_b, b in grid.data {
		if b != 1 || idx_a == idx_b {
			continue
		}
		pos_b := grid.pos_at_idx(idx_b)
		b_diff := pos_b - pos_a
		unit := b_diff.factorized()
		mut blocked := false
		for pos := pos_a + unit; !pos.eq(pos_b); pos = pos + unit {
			idx_c := grid.idx_at_pos(pos)
			if grid.data[idx_c] == 1 {
				blocked = true
				break
			}
		}
		if !blocked {
			count++
			if !count_only {
				seen << pos_b
				angle := b_diff.angle()
				for i, pos_c in seen {
					c_diff := pos_c - pos_a
					if angle < c_diff.angle() {
						mut shift := pos_b
						for j, next in seen[i..] {
							seen[j + i] = shift
							shift = next
						}
						break
					}
				}
			}
		}
	}
	return VisibleAsteroidsResult{
		count: count
		data: seen
	}
}

pub fn day10() {
	lines := os.read_lines('input/input10') or {
		panic(err)
	}
	mut grid := grid.from_lines(lines, ['.', '#'])
	mut best := 0
	mut best_idx := -1
	for idx, c in grid.data {
		if c != 1 {
			continue
		}
		seen := visible_asteroids(grid, idx, true).count
		if seen > best {
			best = seen
			best_idx = idx
		}
	}
	print('\t${best}')
	mut shot := 0
	for shot < 200 {
		visible := visible_asteroids(grid, best_idx, false).data
		base := grid.pos_at_idx(best_idx)
		$if debug {
			println('loop')
		}
		for pos in visible {
			idx := grid.idx_at_pos(pos)
			grid.data[idx] = 0
			shot++
			$if debug {
				diff := pos - base
				angle := diff.angle()
				println('$shot| $base - $pos = $diff ($angle)')
			}
			if shot == 200 {
				print('\t${pos.x * 100 + pos.y}')
				break
			}
		}
	}
}

// Pitfalls today:
// It's not yet possible to expand arrays passed in functions
// Opted to insert element first, then make a function that assumes
// the last element needs sorting.
// Got some kinda of c error where V passed by reference but called functions
// as if direct value. Had to keep sorting in the loop code.
