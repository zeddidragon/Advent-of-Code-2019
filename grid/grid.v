module grid
import dim2

pub struct Grid {
  encoding []string
  pub:
    width int
    height int
  mut:
    data []int
}

pub fn new(data []int, width int, encoding []string) Grid {
  return Grid {
    data: data
    width: width
    height: data.len / width
    encoding: encoding
  }
}

pub fn from_lines(lines []string, encoding []string) Grid {
  width := lines[0].len
  height := lines.len
  mut data := [0].repeat(width * height)
  for j, line in lines {
    for i, c in line.split('') {
      idx := i + j * width
      data[idx] = encoding.index(c)
    }
  }
  return Grid {
    data: data
    width: width
    height: height
    encoding: encoding
  }
}

pub fn from_map(data map[string]int, width int, height int, encoding []string) Grid {
  mut grid_data := [0].repeat(width * height)
  mut idx := 0
  for y in 0..height {
    for x in 0..width {
      key := '$x,$y'
      value := data[key]
      if value != 0 { grid_data[idx] = value }
      idx++
    }
  }
  return Grid {
    data: grid_data
    width: width
    height: height
    encoding: encoding
  }
}

pub fn (g Grid) str() string {
  mut result := ''
  for i, c in g.data {
    result += g.encoding[c]
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
