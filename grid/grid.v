module grid
import dim2

pub struct Grid {
  pub:
    width int
    height int
  mut:
    data []byte
}

pub fn new(data []byte, width int) Grid {
  return Grid {
    data: data
    width: width
    height: data.len / width
  }
}

pub fn from_lines(lines []string) Grid {
  width := lines[0].len
  height := lines.len
  mut data := [`.`].repeat(width * height)

  for j, line in lines {
    for i, c in line.split('') {
      idx := i + j * width
      data[idx] = c[0]
    }
  }

  return Grid {
    data: data
    width: width
    height: height
  }
}

pub fn (g Grid) str() string {
  mut result := ''
  for i, c in g.data {
    result += c.str()
    if i % g.width == g.width - 1 { result += '\n' }
  }
  return result
}

pub fn (g Grid) pos_at_idx(idx int) dim2.Vec {
  return dim2.Vec { idx % g.width, idx / g.height }
}

pub fn (g Grid) idx_at_pos(pos dim2.Vec) int {
  return pos.x + pos.y * g.width
}
