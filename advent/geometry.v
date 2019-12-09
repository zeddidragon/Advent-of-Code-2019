module advent

struct Vec2 {
  mut:
    x i64
    y i64
}

fn (p Vec2) copy() Vec2 {
  return Vec2 {p.x, p.y}
}

pub fn (p Vec2) str() string {
  return '($p.x,$p.y)'
}

fn (p mut Vec2) move(dir byte, dist i64) {
  match dir {
    `L` { p.x -= dist }
    `R` { p.x += dist }
    `U` { p.y -= dist }
    `D` { p.y += dist }
    else {}
  }
}

fn (p Vec2) manhattan() i64 {
  return abs(p.x) + abs(p.y)
}

fn (a Vec2) manhattan_to(b Vec2) i64 {
  return (a - b).manhattan()
}

fn (a Vec2) + (b Vec2) Vec2 {
  return Vec2 {a.x + b.x, a.y + b.y}
}

fn (a Vec2) - (b Vec2) Vec2 {
  return Vec2 {a.x - b.x, a.y - b.y}
}

fn (a Vec2) * (s i64) Vec2 {
  return Vec2 {a.x * s, a.y * s }
}

struct Line2 {
  a Vec2
  b Vec2
}

pub fn (l Line2) str() string {
  return '[$l.a-$l.b]'
}

fn (l Line2) manhattan() i64 {
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

fn (box Box2) left()   i64 { return box.pos.x }
fn (box Box2) right()  i64 { return box.pos.x + box.dims.x }
fn (box Box2) top()    i64 { return box.pos.y }
fn (box Box2) bottom() i64 { return box.pos.y + box.dims.y }

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
