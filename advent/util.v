module advent

fn arr_copy(arr []int) []int {
  return arr.map(it)
}

fn arr_eq(a []int, b []int) bool {
  if a.len != b.len { return false }
  for i, a_el in a {
    if a_el != b[i] { return false }
  }
  return true
}

fn print_arr(arr []int) {
  for i in arr { print('$i,') }
}
