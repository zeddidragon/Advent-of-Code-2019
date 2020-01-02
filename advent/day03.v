module advent

import os
import dim2

struct Stretch {
	id   int
	cost int
	line dim2.Line
}

struct Intersection {
	cost int
	pos  dim2.Vec
}

pub fn day03() {
	f := os.read_file('input/input03') or {
		panic(err)
	}
	wires := f.split('\n')
	mut lines := []Stretch
	mut inters := []Intersection
	for j, wire in wires {
		id := j + 1
		mut pos := dim2.Vec{
			0,0}
		mut cost := 0
		for move in wire.split(',') {
			prev := pos.copy()
			dist := move[1..].int()
			pos = pos.move(move[0], dist)
			l1 := dim2.Line{
				prev,pos.copy()}
			// Todo: reduce cost after self-intersection
			// This was sufficient to solve my input
			for l2 in lines {
				if id == l2.id {
					continue
				}
				inter := l1.inter(l2.line) or {
					continue
				}
				inter_cost := cost + prev.manhattan_to(inter) + l2.cost + l2.line.a.manhattan_to(inter)
				inters << Intersection{
					inter_cost,inter}
			}
			lines << Stretch{
				id,cost,l1}
			cost += dist
		}
	}
	mut shortest := inters[1].pos.manhattan()
	for inter in inters[1..] {
		dist := inter.pos.manhattan()
		if dist < shortest {
			shortest = dist
		}
	}
	print('\t$shortest')
	shortest = inters[1].cost
	for inter in inters[1..] {
		total := inter.cost
		if total < shortest {
			shortest = total
		}
	}
	print('\t$shortest')
}
