module imath

pub fn min(a int, b int) int {
  if a < b { return a }
  return b
}

pub fn max(a int, b int) int {
  if a > b { return a }
  return b
}

pub fn max64(a i64, b i64) i64 {
  if a > b { return a }
  return b
}

pub fn abs(a int) int {
  if a < 0 { return -a }
  return a
}

pub fn sign(a int) int {
  if a == 0 { return 0 }
  if a < 0 { return -1 }
  return 1
}

pub fn is_factor(v int, div int) bool {
  return (v / div) * div == v
}

pub fn is_factor64(v i64, div i64) bool {
  return (v / div) * div == v
}

pub fn largest_factor(a int, b int) int {
  if a == 0 || b == 0 || a == b { return  max(a, b) }
  for i := max(a, b) / 2; i > 1; i-- {
    if is_factor(a, i) && is_factor(b, i) { return i }
  }
  return 1
}

pub fn primes_until(limit i64) []i64 {
  mut primes := []i64
  mut num := i64(2)
  for num <= limit {
    mut is_prime := true
    for prime in primes {
      if is_factor64(num, prime) {
        is_prime = false
        break
      }
    }
    if is_prime { primes << num }
    num++
  }
  return primes
}

pub fn division_count(product i64, div i64) int {
  if div < 2 { return 0 }
  mut dividend := product
  mut count := 0
  for is_factor64(dividend, div) {
    count++
    dividend = dividend / div
  }
  return count
}

pub fn divide_ceil64(v i64, div i64) i64 {
  if is_factor64(v, div) { return v / div }
  return v / div + 1
}

pub fn pow(base i64, exp int) i64 {
  mut v := i64(1)
  for i := 0; i < exp; i++ {
    v *= base
  }
  return v
}

pub fn nth_digit(v i64, exp int) int {
  return int(v / imath.pow(10, exp) % 10)
}

pub fn has_digit(base i64, digit int) bool {
  for div := 1; base / div > 0; div *= 10 {
    if base / div % 10 == digit { return true }
  }
  return false
}
