module advent

import os

fn valid(code int, strict bool) bool {
	mut streak := 0
	mut pairs := 0
	mut prev := 10
	for mag := 1; code / mag > 0; mag *= 10 {
		digit := (code / mag) % 10
		if digit > prev {
			return false
		}
		if digit == prev {
			streak++
			if streak == 1 {
				pairs++
			}
			if streak == 2 && strict {
				pairs--
			}
		}
		else {
			prev = digit
			streak = 0
		}
	}
	return pairs > 0
}

fn count(range []int, strict bool) int {
	mut n := 0
	for i := range[0]; i <= range[1]; i++ {
		if valid(i, strict) {
			n++
		}
	}
	return n
}

pub fn day04() {
	f := os.read_file('input/input04') or {
		panic(err)
	}
	lines := f.split('-')
	range := lines.map(it.int())
	print('\t${count(range, false)}')
	print('\t${count(range, true)}')
}
