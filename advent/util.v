module advent

fn arr_copy(arr []int) []int {
  return arr.map(it)
}

fn print_arr(arr []int) {
  for i in arr { print('$i,') }
}

fn print_grid(arr []byte, width int) {
  for i, c in arr {
    print(c.str())
    if i % width == width - 1 { println('') }
  }
}
