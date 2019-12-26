module advent
import os
import intcode


pub fn day25() {
  f := os.read_file('input/input25') or { panic(err) }
  mem_str := f.split(',')
  mem := mem_str.map(it.i64())

  mut machine := intcode.new(mem)
  for {
    result := machine.run() or { panic(err) }
    match result.state {
      .yield { print(byte(result.value).str()) }
      .done { break }
      .await {
        input := os.get_line()
        machine.feed_ascii(input)
        machine.feed(10)
      }
    }
  }
}
