module geometry
import math
import imath

pub struct Vecf {
  pub mut:
    x f64
    y f64
}

pub fn (v Vecf) normalize() Vecf {
  len := math.sqrt(v.x * v.x + v.y * v.y)
  return Vecf { v.x / len, v.y / len }
}

pub fn (v Vecf) angle() f64 {
  return math.atan2(v.y, v.x)
}

pub struct Vec2 {
  pub mut:
    x int
    y int
}

pub fn (p Vec2) copy() Vec2 {
  return Vec2 {p.x, p.y}
}

pub fn (p Vec2) str() string {
  return '($p.x,$p.y)'
}

pub fn (p mut Vec2) move(dir byte, dist int) {
  match dir {
    `L` { p.x -= dist }
    `R` { p.x += dist }
    `U` { p.y -= dist }
    `D` { p.y += dist }
    else {}
  }
}

pub fn (p Vec2) manhattan() int {
  return imath.abs(p.x) + imath.abs(p.y)
}

pub fn (a Vec2) manhattan_to(b Vec2) int {
  return (a - b).manhattan()
}

pub fn (a Vec2) + (b Vec2) Vec2 {
  return Vec2 {a.x + b.x, a.y + b.y}
}

pub fn (a Vec2) - (b Vec2) Vec2 {
  return Vec2 {a.x - b.x, a.y - b.y}
}

pub fn (a Vec2) * (s int) Vec2 {
  return Vec2 {a.x * s, a.y * s}
}

pub fn (a Vec2) / (s int) Vec2 {
  return Vec2 {a.x / s, a.y / s}
}

pub fn (p Vec2) factorized() Vec2 {
  factor := imath.largest_factor(imath.abs(p.x), imath.abs(p.y))
  return Vec2 {p.x / factor, p.y / factor}
}

pub fn (a Vec2) eq(b Vec2) bool {
  return a.x == b.x && a.y == b.y
}

pub fn (a Vec2) contains(b Vec2) bool {
  return a.factorized().eq(b.factorized())
}

pub fn(p Vec2) angle() f64 {
  vec := Vecf { f64(p.x), f64(p.y) }
  return vec.normalize().angle()
}

pub struct Line2 {
  pub:
    a Vec2
    b Vec2
}

pub fn (l Line2) str() string {
  return '[$l.a-$l.b]'
}

pub fn (l Line2) manhattan() int {
  return l.a.manhattan_to(l.b)
}

pub fn (l Line2) orthogonal() bool {
  return l.a.x == l.b.x || l.a.y == l.b.y
}

pub fn (l Line2) box() Box2 {
  x := imath.min(l.a.x, l.b.x)
  y := imath.min(l.a.y, l.b.y)
  w := imath.abs(l.a.x - l.b.x)
  h := imath.abs(l.a.y - l.b.y)
  return Box2{
    pos: Vec2 {x,y}
    dims: Vec2 {w,h}
  }
}

pub fn (line Line2) inter(other Line2) ?Vec2 {
  if line.orthogonal() && other.orthogonal() {
    bounds := line.box().inter(other.box()) or {
      return error('lines do not intersect')
    }
    return bounds.pos
  }

  return error('diagonals not implemented')
}

pub struct Box2 {
  pos Vec2
  dims Vec2
}

pub fn (box Box2) left()   int { return box.pos.x }
pub fn (box Box2) right()  int { return box.pos.x + box.dims.x }
pub fn (box Box2) top()    int { return box.pos.y }
pub fn (box Box2) bottom() int { return box.pos.y + box.dims.y }

pub fn (box Box2) inter(other Box2) ?Box2 {
  x := imath.max(box.left(), other.left())
  y := imath.max(box.top(), other.top())
  right := imath.min(box.right(), other.right())
  bottom := imath.min(box.bottom(), other.bottom())

  if right >= x && bottom >= y {
    return Box2 {
      pos: Vec2 {x,y}
      dims: Vec2 {right - x, bottom - y}
    }
  }

  return error('boxes do not intersect')
}
