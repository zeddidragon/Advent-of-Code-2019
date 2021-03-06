module dim2

import math
import imath

pub struct Vecf {
pub mut:
	x f64
	y f64
}

pub fn (v Vecf) normalize() Vecf {
	len := math.sqrt(v.x * v.x + v.y * v.y)
	return Vecf{
		v.x / len,v.y / len}
}

pub fn (v Vecf) angle() f64 {
	angle := math.atan2(v.x, -v.y)
	if angle < 0 {
		return 2.0 * math.pi - math.abs(angle)
	}
	else {
		return angle
	}
}

pub struct Vec {
pub mut:
	x int
	y int
}

pub fn vec(x int, y int) Vec {
	return Vec{
		x,y}
}

pub fn (p Vec) copy() Vec {
	return Vec{
		p.x,p.y}
}

pub fn (p Vec) str() string {
	return '($p.x,$p.y)'
}

pub fn (p Vec) key() string {
	return '$p.x,$p.y'
}

pub fn (p Vec) move(dir byte, dist int) Vec {
	return match dir {
		`L`{
			Vec{
				p.x - dist,p.y}
		}
		`R`{
			Vec{
				p.x + dist,p.y}
		}
		`U`{
			Vec{
				p.x,p.y - dist}
		}
		`D`{
			Vec{
				p.x,p.y + dist}
		}
		else {
			p.copy()}
	}
}

pub fn (p Vec) dir_char() byte {
	if p.x < 0 {
		return `L`
	}
	if p.x > 0 {
		return `R`
	}
	if p.y < 0 {
		return `U`
	}
	if p.y > 0 {
		return `D`
	}
	return `?`
}

pub fn (p Vec) turn(dir byte) Vec {
	return match dir {
		`L`{
			Vec{
				p.y,-p.x}
		}
		`R`{
			Vec{
				-p.y,p.x}
		}
		`B`{
			Vec{
				-p.x,-p.y}
		}
		else {
			p.copy()}
	}
}

pub fn (p Vec) manhattan() int {
	return imath.abs(p.x) + imath.abs(p.y)
}

pub fn (a Vec) manhattan_to(b Vec) int {
	return (a - b).manhattan()
}

pub fn (a Vec) +(b Vec) Vec {
	return Vec{
		a.x + b.x,a.y + b.y}
}

pub fn (a Vec) -(b Vec) Vec {
	return Vec{
		a.x - b.x,a.y - b.y}
}

pub fn (a Vec) scalar(s int) Vec {
	return Vec{
		a.x * s,a.y * s}
}

pub fn (a Vec) scalar_div(s int) Vec {
	return Vec{
		a.x / s,a.y / s}
}

pub fn (p Vec) factorized() Vec {
	factor := imath.largest_factor(imath.abs(p.x), imath.abs(p.y))
	return Vec{
		p.x / factor,p.y / factor}
}

pub fn (a Vec) eq(b Vec) bool {
	return a.x == b.x && a.y == b.y
}

pub fn (a Vec) contains(b Vec) bool {
	return a.factorized().eq(b.factorized())
}

pub fn (p Vec) angle() f64 {
	vec := Vecf{
		f64(p.x),f64(p.y)}
	return vec.normalize().angle()
}

pub struct Line {
pub:
	a Vec
	b Vec
}

pub fn (l Line) str() string {
	return '[$l.a-$l.b]'
}

pub fn (l Line) manhattan() int {
	return l.a.manhattan_to(l.b)
}

pub fn (l Line) orthogonal() bool {
	return l.a.x == l.b.x || l.a.y == l.b.y
}

pub fn (l Line) box() Box {
	x := imath.min(l.a.x, l.b.x)
	y := imath.min(l.a.y, l.b.y)
	w := imath.abs(l.a.x - l.b.x)
	h := imath.abs(l.a.y - l.b.y)
	return Box{
		pos: Vec{
			x,y}
		dims: Vec{
			w,h}
	}
}

pub fn (line Line) inter(other Line) ?Vec {
	if line.orthogonal() && other.orthogonal() {
		bounds := line.box().inter(other.box()) or {
			return error('lines do not intersect')
		}
		return bounds.pos
	}
	return error('diagonals not implemented')
}

pub struct Box {
	pos  Vec
	dims Vec
}

pub fn (box Box) left() int {
	return box.pos.x
}

pub fn (box Box) right() int {
	return box.pos.x + box.dims.x
}

pub fn (box Box) top() int {
	return box.pos.y
}

pub fn (box Box) bottom() int {
	return box.pos.y + box.dims.y
}

pub fn (box Box) inter(other Box) ?Box {
	x := imath.max(box.left(), other.left())
	y := imath.max(box.top(), other.top())
	right := imath.min(box.right(), other.right())
	bottom := imath.min(box.bottom(), other.bottom())
	if right >= x && bottom >= y {
		return Box{
			pos: Vec{
				x,y}
			dims: Vec{
				right - x,bottom - y}
		}
	}
	return error('boxes do not intersect')
}
