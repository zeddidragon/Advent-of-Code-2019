module advent
import os
import dim3
import imath
import array


struct MoonState {
  mut:
    pos []int
    vel []int
}

fn (ms mut MoonState) step(slice int) {
  len := ms.pos.len / slice
  for k in 0..slice {
    at := k * len
    to := at + len
    for j, a in ms.pos[at..to] {
      for i, b in ms.pos[at..to] {
        if i == j { continue }
        diff := imath.sign(b - a)
        if diff != 0 { ms.vel[at + j] = ms.vel[at + j] + diff }
      }
    }
  }

  for i, v in ms.vel {
    ms.pos[i] = ms.pos[i] + v
  }
}

fn (ms MoonState) energy() int {
  mut energy := 0
  len := ms.pos.len / 3
  mut pos := [0].repeat(len)
  mut vel := [0].repeat(len)
  for i, p in ms.pos {
    idx := i % len
    pos[idx] = pos[idx] + imath.abs(p)
  }
  for i, v in ms.vel {
    idx := i % len
    vel[idx] = vel[idx] + imath.abs(v)
  }
  for i, p in pos {
    energy += p * vel[i]
  }
  return energy
}

fn parse_vec3(line string) dim3.Vec {
  defs := line[1..(line.len - 1)].split(',')
  coords := defs.map(it.split('=')[1].int())
  return dim3.Vec { coords[0], coords[1], coords[2] }
}

fn vec3_arr_to_int_arr(vecs []dim3.Vec) []int {
  mut ret := []int
  for j in 0..3 {
    component := vecs.map(it.coord(j))
    ret << component
  }
  return ret
}

fn new_moon_state(pos_comps []int) MoonState {
  return MoonState {
    pos: array.clone(pos_comps)
    vel: [0].repeat(pos_comps.len)
  }
}

pub fn day12() {
  lines := os.read_lines('input/input12') or { panic(err) }
  mut poss := [dim3.Vec { 0, 0, 0 }].repeat(lines.len)
  for i, line in lines {
    poss[i] = parse_vec3(line)
  }
  pos_comps := vec3_arr_to_int_arr(poss)

  mut ms := new_moon_state(pos_comps)
  for _ in 0..1000 { ms.step(3) }
  print('\t${ms.energy()}')

  mut counts := []int
  zero_vel := [0].repeat(poss.len)
  for j in 0..3 {
    mut slice := pos_comps[(j * poss.len)..((j + 1) * poss.len)]
    ms = new_moon_state(slice)
    mut count := 0
    for {
      ms.step(1)
      count++
      if array.eq(ms.pos, slice) && array.eq(ms.vel, zero_vel) {
        break
      }
    }
    counts << count
  }

  mut common := i64(0)
  for n in counts { if i64(n) > common { common = i64(n) } }
  mut a := common
  for n in counts { if i64(n) < a { a = i64(n) } }
  mut b := a
  for n in counts { if i64(n) > a && i64(n) < common { b = i64(n) } }

  // Cheapo optimization, may not work for your purposes
  primes := imath.primes_until(common / 2)
  mut prime_counts := [0].repeat(primes.len)
  for product in [common, a, b] {
    for i, prime in primes {
      divs := imath.division_count(product, prime)
      if divs == 0 { continue }
      prime_counts[i] = divs
    }
  }
  mut product := i64(2) // ??? Why is 1 half the right answer?
  for i, count in prime_counts {
    if count < 1 { continue }
    product *= primes[i] * i64(count)
  }
  print('\t$product')
}


// Pitfalls today:
// Initially I has this loop:
// for i in 0..3 {
//   initial := poss.map(it.coord(i))
//   println(initial)
// }
// This traversed the vectors "diagonally" because
// .map() uses `i` as its counter internally
// changing `i` to `j` solved it
// Arrays of arrays are also not supported
// One day that is going to be a showstopper
// but not today
