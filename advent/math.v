module advent

fn min(a int, b int) int {
  if a < b { return a }
  return b
}

fn max(a int, b int) int {
  if a > b { return a }
  return b
}

fn abs(a int) int {
  if a < 0 { return -a }
  return a
}

fn pow(base int, exp int) int {
  mut v := 1
  for i := 0; i < exp; i++ {
    v *= base
  }
  return v
}

fn nth_digit(v int, exp int) int {
  return v / pow(10, exp) % 10
}

fn has_digit(base int, digit int) bool {
  for div := 1; base / div > 0; div *= 10 {
    if base / div % 10 == digit { return true }
  }
  return false
}
