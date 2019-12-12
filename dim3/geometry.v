module dim3
import imath

pub struct Vec {
  pub mut:
    x int
    y int
    z int
}

pub fn (p Vec) copy() Vec {
  return Vec { p.x, p.y, p.z }
}

pub fn (p Vec) str() string {
  return '($p.x,$p.y,$p.z)'
}

pub fn (p Vec) manhattan() int {
  return imath.abs(p.x) + imath.abs(p.y) + imath.abs(p.z)
}

pub fn (a Vec) manhattan_to(b Vec) int {
  return (a - b).manhattan()
}

pub fn (p Vec) coord(n int) int {
  return match n {
    0 { p.x }
    1 { p.y }
    2 { p.z }
    else { 0 }
  }
}

pub fn (a Vec) + (b Vec) Vec {
  return Vec {a.x + b.x, a.y + b.y, a.z + b.z}
}

pub fn (a Vec) - (b Vec) Vec {
  return Vec {a.x - b.x, a.y - b.y, a.z - b.z}
}

pub fn (a Vec) * (s int) Vec {
  return Vec {a.x * s, a.y * s, a.z * s}
}

pub fn (a Vec) / (s int) Vec {
  return Vec {a.x / s, a.y / s, a.z / s}
}

pub fn (a Vec) eq(b Vec) bool {
  return a.x == b.x && a.y == b.y && a.z == b.z
}
