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
