module advent

struct Vec2 {
  mut:
    x int
    y int
}

fn (p Vec2) copy() Vec2 {
  return Vec2 {p.x, p.y}
}

pub fn (p Vec2) str() string {
  return '($p.x,$p.y)'
}

fn (p mut Vec2) move(dir byte, dist int) {
  match dir {
    `L` { p.x -= dist }
    `R` { p.x += dist }
    `U` { p.y -= dist }
    `D` { p.y += dist }
    else {}
  }
}

fn (p Vec2) manhattan() int {
  return abs(p.x) + abs(p.y)
}

fn (a Vec2) manhattan_to(b Vec2) int {
  return (a - b).manhattan()
}

fn (a Vec2) + (b Vec2) Vec2 {
  return Vec2 {a.x + b.x, a.y + b.y}
}

fn (a Vec2) - (b Vec2) Vec2 {
  return Vec2 {a.x - b.x, a.y - b.y}
}

fn (a Vec2) * (s int) Vec2 {
  return Vec2 {a.x * s, a.y * s}
}

fn (a Vec2) / (s int) Vec2 {
  return Vec2 {a.x / s, a.y / s}
}

fn (p Vec2) factorized() Vec2 {
  factor := largest_factor(abs(p.x), abs(p.y))
  return Vec2 {p.x / factor, p.y / factor}
}

fn (a Vec2) eq(b Vec2) bool {
  return a.x == b.x && a.y == b.y
}

struct Line2 {
  a Vec2
  b Vec2
}

pub fn (l Line2) str() string {
  return '[$l.a-$l.b]'
}

fn (l Line2) manhattan() int {
  return l.a.manhattan_to(l.b)
}

fn (l Line2) orthogonal() bool {
  return l.a.x == l.b.x || l.a.y == l.b.y
}

fn (l Line2) box() Box2 {
  x := min(l.a.x, l.b.x)
  y := min(l.a.y, l.b.y)
  w := abs(l.a.x - l.b.x)
  h := abs(l.a.y - l.b.y)
  return Box2{
    pos: Vec2 {x,y}
    dims: Vec2 {w,h}
  }
}

fn (line Line2) inter(other Line2) ?Vec2 {
  if line.orthogonal() && other.orthogonal() {
    bounds := line.box().inter(other.box()) or {
      return error('lines do not intersect')
    }
    return bounds.pos
  }

  return error('diagonals not implemented')
}

struct Box2 {
  pos Vec2
  dims Vec2
}

fn (box Box2) left()   int { return box.pos.x }
fn (box Box2) right()  int { return box.pos.x + box.dims.x }
fn (box Box2) top()    int { return box.pos.y }
fn (box Box2) bottom() int { return box.pos.y + box.dims.y }

fn (box Box2) inter(other Box2) ?Box2 {
  x := max(box.left(), other.left())
  y := max(box.top(), other.top())
  right := min(box.right(), other.right())
  bottom := min(box.bottom(), other.bottom())

  if right >= x && bottom >= y {
    return Box2 {
      pos: Vec2 {x,y}
      dims: Vec2 {right - x, bottom - y}
    }
  }

  return error('boxes do not intersect')
}
