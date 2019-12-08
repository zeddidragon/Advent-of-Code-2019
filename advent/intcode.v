module advent

enum IntState {
  done
  await
  yield
  throw
}

struct IntMachine {
  mut:
    mem []int
    pos int
    input int
    has_input bool
}

struct IntResult {
  state IntState
  value int
}

fn ic_init(mem []int) IntMachine {
  return IntMachine { arr_copy(mem), 0, 0, false }
}

fn (m mut IntMachine) feed(input int) {
  m.input = input
  m.has_input = true
}

fn (m IntMachine) ptr(idx int) int {
  return m.mem[m.mem[idx]]
}

fn (m IntMachine) arg(n int) int {
  op := m.mem[m.pos]
  idx := m.pos + n + 1
  p := pow(10, n + 1)
  mode := (op / p) % 10
  v := m.mem[idx]
  if mode == 0 { return m.mem[v] }
  if mode == 1 { return v }
  println("Unknown mode: $mode (@${m.pos})")
  return 0
}

fn (m mut IntMachine) w_arg(n int, value int) {
  idx := m.pos + n + 1
  m.mem[m.mem[idx]] = value
}

fn (m mut IntMachine) run_until_result() ?int {
  for {
    result := m.run() or { panic }
    match result.state {
      .done { return error('result never yielded') }
      .await { return error('machine needs more input') }
      else { if result.value != 0 { return result.value } }
    }
  }
  return 0 // Appease compiler
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
      else { 0 }
    }
    jump = m.pos + argc + 1

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
      99 { return IntResult { IntState.done, 0 } } // exit
      else { return error('opcode not implemented: $op') }
    }

    $if debug {
      println('jump: $jump')
    }
  }

  return IntResult { IntState.done, 1 }
}
