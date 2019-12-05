module advent

fn day(d int, part int) {
  println("# Day $d - $part")
}

fn arr_copy(arr []int) []int {
  return arr.map(it)
}

fn print_arr(arr []int) {
  for i in arr { print(i) }
}
