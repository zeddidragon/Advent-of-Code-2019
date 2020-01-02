module advent

import os

fn count_orbits(orbits map[string]string, body string) int {
	mut n := 0
	for current := body; ; n++ {
		if !(current in orbits) {
			break
		}
		current = orbits[current]
	}
	return n
}

fn trace_orbit(orbits map[string]string, body string) []string {
	mut path := []string
	for current := body; ;  {
		if !(current in orbits) {
			break
		}
		current = orbits[current]
		path << current
	}
	return path
}

pub fn day06() {
	f := os.read_lines('input/input06') or {
		panic(err)
	}
	mut orbits := map[string]string
	bodies := f.map(it.split(')')[1])
	for line in f {
		split := line.split(')')
		orbits[split[1]] = split[0]
	}
	mut total := 0
	for body in bodies {
		total += count_orbits(orbits, body)
	}
	print('\t$total')
	you_path := trace_orbit(orbits, 'YOU')
	san_path := trace_orbit(orbits, 'SAN')
	for j, a in you_path {
		for i, b in san_path {
			if a == b {
				print('\t${i + j}')
				return
			}
		}
	}
}
