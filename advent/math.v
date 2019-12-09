module advent

fn min(a i64, b i64) i64 {
  if a < b { return a }
  return b
}

fn max(a i64, b i64) i64 {
  if a > b { return a }
  return b
}

fn abs(a i64) i64 {
  if a < 0 { return -a }
  return a
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
