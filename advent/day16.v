module advent
import os
import imath
import array


const (
  signal_pattern = [0, 1, 0, -1]
)

fn signal_product(signal []int, digit int) int {
  mut result := 0
  mut phase := 0
  mut dupe := digit
  for n in signal {
    dupe--
    if dupe < 0 {
      phase = (phase + 1) % signal_pattern.len
      dupe = digit
    }
    result += n * signal_pattern[phase]
  }
  return imath.abs(result) % 10

}

fn process_signal(signal []int) []int {
  i := 0 // Not really used, just need to avoid compiler error
  return signal.map(signal_product(signal, i))
}

pub fn day16() {
  f := os.read_lines('input/input16') or { panic(err) }
  num_strs := f[0].split('')
  input := num_strs.map(it.int())
  mut nums := array.clone(input)

  for _ in 0..100 {
    nums = process_signal(nums)
  }
  first8 := array.arr_str(nums[0..8], '')
  print('\t$first8')

  mut offset := 0
  for i, n in input[0..7] {
    offset += int(imath.pow(10, 6 - i)) * n
  }
  nums = array.clone(input).repeat(10000)
  nums = nums[offset..]
  for _ in 0..100 {
    mut next_nums := [0].repeat(nums.len)
    mut sum := 0
    mut prev := 0
    for n in nums { sum += n }
    for i, n in nums {
      sum -= prev
      prev = n
      next_nums[i] = imath.abs(sum) % 10
    }
    nums = next_nums
  }
  real8 := array.arr_str(nums[0..8], '')
  print('\t$real8')
}
