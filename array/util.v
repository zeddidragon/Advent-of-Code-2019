module array

pub fn clone(arr []int) []int {
  return arr.map(it)
}

pub fn eq(a []int, b []int) bool {
  if a.len != b.len { return false }
  for i, a_el in a {
    if a_el != b[i] { return false }
  }
  return true
}

pub fn arr_str(arr []int, sep string) string {
  mut ret := ''
  for n in arr { ret += '$n$sep' }
  return ret
}
