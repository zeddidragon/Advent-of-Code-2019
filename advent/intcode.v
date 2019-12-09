module advent

enum IntState {
  done
  await
  yield
}

struct IntMachine {
  mut:
    mem []i64
    pos int
    base int
    input i64
    has_input bool
}

struct IntResult {
  state IntState
  value i64
}

fn ic_init(mem []i64) IntMachine {
  mem_copy := mem.map(it)
  return IntMachine {
    mem: mem_copy
    pos: 0
    base: 0
    input: 0
    has_input: false
  }
}

fn (m mut IntMachine) feed(input i64) {
  m.input = input
  m.has_input = true
}

fn (m IntMachine) arg(n int) i64 {
  op := m.mem[m.pos]
  idx := m.pos + n + 1
  mode := nth_digit(op, n + 2)
  v := if idx >= m.mem.len { 0 } else { m.mem[idx] }
  access := match mode {
    0 { int(v) }
    1 { idx }
    2 { m.base + int(v) }
    else { -1 }
  }
  if access >= m.mem.len { return 0 }
  return m.mem[access]
}

fn (m mut IntMachine) w_arg(n int, value i64) {
  idx := m.pos + n + 1
  if idx >= m.mem.len {
    m.mem << [i64(0)].repeat(idx - m.mem.len)
  }
  m.mem[m.mem[idx]] = value
}

fn (m mut IntMachine) run_until_result() ?i64 {
  for {
    result := m.run() or { panic(err) }
    match result.state {
      .done { return error('result never yielded') }
      .await { return error('machine needs more input') }
      else { if result.value != 0 { return result.value } }
    }
  }
  return i64(0) // Appease compiler
}

fn (m mut IntMachine) run() ?IntResult {
  for jump := m.pos; m.pos < m.mem.len; m.pos = jump {
    op := m.mem[m.pos]
    argc := match op % 100 {
      1 { 3 }
      2 { 3 }
      3 { 1 }
      4 { 1 }
      5 { 2 }
      6 { 2 }
      7 { 3 }
      8 { 3 }
      9 { 1 }
      else { 0 }
    }
    jump = m.pos + argc + 1

    $if debug {
      print('op: $op  ')
      for i in 0..argc {
        print("arg$i: ${m.arg(i)}  ")
      }
      print('\n')
    }

    match op % 100 {
      1 { m.w_arg(2, m.arg(0) + m.arg(1)) } // add
      2 { m.w_arg(2, m.arg(0) * m.arg(1)) } // mul
      3 { // read
        if m.has_input {
          m.w_arg(0, m.input)
          m.has_input = false
        } else {
          return IntResult { IntState.await, 0 }
        }
      }
      4 {
        result := m.arg(0)
        m.pos = jump
        return IntResult { IntState.yield, result }
      } // yield
      5 { if m.arg(0) != 0 { jump = m.arg(1) } } // if
      6 { if m.arg(0) == 0 { jump = m.arg(1) } } // unless
      7 { // lt
        v := match m.arg(0) < m.arg(1) {
          true { 1 }
          else { 0 }
        }
        m.w_arg(2, v)
      }
      8 { // eq
        v := match m.arg(0) == m.arg(1) {
          true { 1 }
          else { 0 }
        }
        m.w_arg(2, v)
      }
      9 { m.base += m.arg(0) } //rel
      99 { return IntResult { IntState.done, 0 } } // exit
      else { return error('opcode not implemented: $op') }
    }
  }

  return IntResult { IntState.done, 1 }
}
