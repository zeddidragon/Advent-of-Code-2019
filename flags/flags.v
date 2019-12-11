module flags
import os


pub fn num(name string) int {
  idx := os.args.index('-' + name)
  if idx < 0 { return 0 }
  return os.args[idx + 1].int()
}

pub fn has(name string) bool {
  idx := os.args.index('-' + name)
  return idx >= 0
}
