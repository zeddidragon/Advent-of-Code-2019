module flags
import os


pub fn get(name string) int {
  for i, arg in os.args {
    if arg[1..] != name { continue }
    return match name {
      'day' { os.args[i + 1].int() }
      else { 1 }
    }
  }
  return 0
}
