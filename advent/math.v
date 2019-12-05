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
  mut v := base
  for i := 0; i < exp; i++ {
    v *= base
  }
  return v
}
