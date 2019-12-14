module advent
import os
import imath


struct Resource {
  name string
  amount i64
}

pub fn (r Resource) str() string {
  return '$r.amount $r.name'
}

fn parse_resource(str string) Resource {
  sides := str.split(' ')
  return Resource {
    amount: sides[0].i64()
    name: sides[1]
  }
}

struct ResourceProcess {
  required []Resource
  out Resource
}

pub fn (rp ResourceProcess) str() string {
  mut out := ''
  for r in rp.required {
    out += '$r '
  }
  out += '=> $rp.out'
  return out
}

struct ResourceFactory {
  dry_run bool
  processes map[string]ResourceProcess
  pub mut:
    resources map[string]i64

}

fn new_resource_factory(processes map[string]ResourceProcess) ResourceFactory {
  resources := map[string]i64
  return ResourceFactory {
    processes: processes
    resources: resources
  }
}

fn (rf mut ResourceFactory) consume(name string, amount i64) {
  if name == 'ORE' { // ORE is free
    rf.resources[name] = rf.resources[name] + amount
    return
  }
  rf.ensure(name, amount)
  rf.resources[name] = rf.resources[name] - amount
}

fn (rf mut ResourceFactory) ensure(name string, amount i64) {
  missing := amount - rf.resources[name]
  if missing <= 0 { return }

  process := rf.processes[name]
  steps := imath.divide_ceil64(missing, process.out.amount)
  for material in process.required {
    rf.consume(material.name, material.amount * steps)
  }
  rf.resources[name] = rf.resources[name] + steps * process.out.amount
}

pub fn day14() {
  f := os.read_lines('input/input14') or { panic(err) }

  mut resources := map[string]i64
  mut processes := map[string]ResourceProcess
  mut resource_arr := []string
  for line in f {
    in_out := line.split(' => ')
    ins := in_out[0].split(', ')
    required := ins.map(parse_resource(it))
    out := parse_resource(in_out[1])
    resource_arr << out.name
    processes[out.name] = ResourceProcess {
      required: required
      out: out
    }
  }

  mut factory := new_resource_factory(processes)
  factory.consume('FUEL', 1)
  ore := factory.resources['ORE']
  print('\t$ore')
}
