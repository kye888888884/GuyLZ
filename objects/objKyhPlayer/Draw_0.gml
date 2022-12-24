/// @description Insert description here
// You can write your code in this editor

draw_self()

draw_set_color(c_blue)
if (r1 != noone) {
	draw_line(r1.src.x, r1.src.y, r1.dest.x, r1.dest.y)
	draw_circle(r1.dest.x, r1.dest.y, 2, false)
	draw_text(16, 16, "r1: (" + string(r1.dest.x) + ", " + string(r1.dest.y) + ")")
}
draw_set_color(c_green)
if (r2 != noone) {
	draw_line(r2.src.x, r2.src.y, r2.dest.x, r2.dest.y)
	draw_circle(r2.dest.x, r2.dest.y, 2, false)
	draw_text(16, 48, "r2: (" + string(r2.dest.x) + ", " + string(r2.dest.y) + ")")
}
draw_set_color(c_fuchsia)
if (r3 != noone) {
	draw_line(r3.src.x, r3.src.y, r3.dest.x, r3.dest.y)
	draw_circle(r3.dest.x, r3.dest.y, 2, false)
	draw_text(16, 80, "r3: (" + string(r3.dest.x) + ", " + string(r3.dest.y) + ")")
}
draw_set_color(-1)
if (floor_normal != noone)
	draw_text(16, 112, "floor: (" + string(floor_normal.x) + ", " + string(floor_normal.y) + ")")
draw_set_color(-1)