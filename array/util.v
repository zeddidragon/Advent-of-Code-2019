module array

pub fn clone(arr []int) []int {
  return arr.map(it)
}

pub fn byte_clone(arr []byte) []byte {
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

pub fn byte_arr_str(arr []byte, sep string) string {
  mut ret := ''
  for n in arr { ret += '${n.str()}$sep' }
  return ret
}
