module advent
import os
import dim3
import imath

fn parse_vec3(line string) dim3.Vec {
  defs := line[1..(line.len - 1)].split(',')
  coords := defs.map(it.split('=')[1].int())
  return dim3.Vec { coords[0], coords[1], coords[2] }
}

pub fn day12() {
  lines := os.read_lines('input/input12') or { panic(err) }
  mut vels := [dim3.Vec { 0, 0, 0 }].repeat(lines.len)
  mut poss := [dim3.Vec { 0, 0, 0 }].repeat(lines.len)
  mut count := 0
  for i, line in lines {
    poss[i] = parse_vec3(line)
  }

  for n in 0..1000 {
    $if debug { println('step: ${n + 1}') }
    for j, pos_a in poss {
      for i, pos_b in poss {
        if i == j { continue }
        x_diff := imath.sign(pos_b.x - pos_a.x)
        y_diff := imath.sign(pos_b.y - pos_a.y)
        z_diff := imath.sign(pos_b.z - pos_a.z)

        if x_diff != 0 { vels[j].x = vels[j].x + x_diff }
        if y_diff != 0 { vels[j].y = vels[j].y + y_diff }
        if z_diff != 0 { vels[j].z = vels[j].z + z_diff }
      }
    }

    for i, vel in vels {
      poss[i] = poss[i] + vel
      $if debug { println('pos: ${poss[i]} vel: $vel') }
    }
  }

  mut energy := 0
  for i, vel in vels {
    energy += poss[i].manhattan() * vel.manhattan()
  }

  println(energy)

  mut pos_axis := int[]
  mut vel_axis := int[]
}
