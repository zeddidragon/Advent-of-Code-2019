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

fn sign(a int) int {
  if a == 0 { return 0 }
  if a < 0 { return -1 }
  return 1
}

fn is_factor(v int, div int) bool {
  return (v / div) * div == v
}

fn largest_factor(a int, b int) int {
  if a == 0 || b == 0 || a == b { return  max(a, b) }
  for i := max(a, b) / 2; i > 1; i-- {
    if is_factor(a, i) && is_factor(b, i) { return i }
  }
  return 1
}

fn pow(base i64, exp int) i64 {
  mut v := i64(1)
  for i := 0; i < exp; i++ {
    v *= base
  }
  return v
}

fn nth_digit(v i64, exp int) int {
  return int(v / pow(10, exp) % 10)
}

fn has_digit(base i64, digit int) bool {
  for div := 1; base / div > 0; div *= 10 {
    if base / div % 10 == digit { return true }
  }
  return false
}
