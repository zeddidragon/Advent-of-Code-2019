module grid
import dim2
import array

pub struct Grid {
  encoding []string
  pub mut:
    width int
    height int
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

pub fn empty(encoding []string) Grid {
  return Grid {
    data: [],
    width: 0,
    height: 0,
    encoding: encoding,
  }
}

pub fn (g mut Grid) read_map(data map[string]int, size dim2.Vec, off dim2.Vec) {
  width := size.x
  height := size.y
  if width != g.width || height != g.height {
    g.data = [0].repeat(width * height)
    g.width = width
    g.height = height
  }
  mut idx := 0
  for y in 0..height {
    for x in 0..width {
      key := '${x + off.x},${y + off.y}'
      value := data[key]
      if value != g.data[idx] { g.data[idx] = value }
      idx++
    }
  }
}

const (
  alpha_order = 'ABCDEHKJRY'.split('')
  alpha_width = 5
  alpha_height = 6
  alpha_size = alpha_width * alpha_height
  alpha_grid = [
    // A
    0,1,1,0,0,
    1,0,0,1,0,
    1,0,0,1,0,
    1,1,1,1,0,
    1,0,0,1,0,
    1,0,0,1,0,
    // B
    1,1,1,0,0,
    1,0,0,1,0,
    1,1,1,0,0,
    1,0,0,1,0,
    1,0,0,1,0,
    1,1,1,0,0,
    // C
    0,1,1,0,0,
    1,0,0,1,0,
    1,0,0,0,0,
    1,0,0,0,0,
    1,0,0,1,0,
    0,1,1,0,0,
    // D
    1,1,1,0,0,
    1,0,0,1,0,
    1,0,0,1,0,
    1,0,0,1,0,
    1,0,0,1,0,
    1,1,1,0,0,
    // D
    1,1,1,1,0,
    1,0,0,0,0,
    1,1,1,0,0,
    1,0,0,0,0,
    1,0,0,0,0,
    1,1,1,1,0,
    // H
    1,0,0,1,0,
    1,0,0,1,0,
    1,1,1,1,0,
    1,0,0,1,0,
    1,0,0,1,0,
    1,0,0,1,0,
    // K
    1,0,0,1,0,
    1,0,1,0,0,
    1,1,0,0,0,
    1,0,1,0,0,
    1,0,1,0,0,
    1,0,0,1,0,
    // J
    0,0,1,1,0,
    0,0,0,1,0,
    0,0,0,1,0,
    0,0,0,1,0,
    1,0,0,1,0,
    0,1,1,0,0,
    // R
    1,1,1,0,0,
    1,0,0,1,0,
    1,0,0,1,0,
    1,1,1,0,0,
    1,0,1,0,0,
    1,0,0,1,0,
    // Y
    1,0,0,0,1,
    1,0,0,0,1,
    0,1,0,1,0,
    0,0,1,0,0,
    0,0,1,0,0,
    0,0,1,0,0,
  ]
  empty_alpha_row = [0,0,0,0,0]
)

pub fn (g Grid) text() string {
  mut text := ''
  mut next_letter := ''
  mut idx := 0
  for {
    if idx + alpha_width > g.data.len { break }
    x := idx % g.width
    y := idx / g.width
    if x + alpha_width > g.width {
      idx = (y + 1) * g.width
      continue
    }
    if y + alpha_height > g.height { break }
    if array.eq(g.data[idx..(idx + 5)], empty_alpha_row) {
      idx += 5
      continue
    }
    for i, letter in alpha_order {
      mut is_equal := true
      for row in 0..alpha_height {
        alpha_start := i * alpha_size + row * alpha_width
        alpha_end := alpha_start + alpha_width
        data_start := idx + g.width * row
        data_end := data_start + alpha_width
        if !array.eq(
          alpha_grid[alpha_start..alpha_end],
          g.data[data_start..data_end]
        ) {
          is_equal = false
          break
        }
      }
      if is_equal {
        next_letter = letter
        break
      }
    }
    if next_letter != '' {
      idx += 5
      text += next_letter
      next_letter = ''
    } else {
      idx++
    }
  }
  return text
}

pub fn (g Grid) str() string {
  mut result := ''
  for i, c in g.data {
    result += g.encoding[c]
    if i % g.width == g.width - 1 { result += '\n' }
  }
  return result
}

pub fn (g Grid) and_return(extra int) string {
  ctrl_up := '\x1b[${g.height + extra}A'
  return '${g.str()}$ctrl_up'
}

pub fn (g Grid) pass(extra int) string {
  return '\n'.repeat(g.height + extra)
}

pub fn (g Grid) pos_at_idx(idx int) dim2.Vec {
  return dim2.Vec { idx % g.width, idx / g.height }
}

pub fn (g Grid) idx_at_pos(pos dim2.Vec) int {
  return pos.x + pos.y * g.width
}
