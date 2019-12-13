module advent
import os
import grid

pub fn day08() {
  f := os.read_file('input/input08') or { panic(err) }
  pixels_str := f.split('')
  pixels := pixels_str.map(it.int())

  width := 25
  height := 6
  page := width * height
  pages := pixels.len / page

  // Part 1: Find least-0 page
  mut best := [width * height, 0, 0]
  for idx in 0..pages {
    range := pixels[(idx * page)..((idx + 1) * page)]
    mut count := [0, 0, 0]
    for pixel in range { count[pixel]++ }
    if count[0] < best[0] { best = count }
  }
  print('\t${best[1] * best[2]}')

  // Part 2: Compose layers
  mut picture := [2].repeat(width * height)
  for p in 0..pages {
    range := pixels[(p * page)..((p + 1) * page)]
    for i, pixel in range {
      if picture[i] == 2 {
        picture[i] = pixel
      }
    }
  }

  message := grid.new(picture, width, ['.', '█', ' '])
  if '-pretty' in os.args { println(message) }
  print('\t${message.text()}')
}

// Pitfall today:

// Strings can only be built using +=
// No join(',') to decide how an array might be rendered.
// The result feels pretty slow.
