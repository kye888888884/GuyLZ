/// @description Insert description here
// You can write your code in this editor

draw_self()

draw_set_color(c_blue)
if (r1.dis > 0) {
	draw_line(r1.src.x, r1.src.y, r1.dest.x, r1.dest.y)
	draw_circle(r1.dest.x, r1.dest.y, 2, false)
	draw_text(16, 16, "r1: " + string(r1.dis))
}
draw_set_color(c_green)
if (r2.dis > 0) {
	draw_line(r2.src.x, r2.src.y, r2.dest.x, r2.dest.y)
	draw_circle(r2.dest.x, r2.dest.y, 2, false)
	draw_text(16, 48, "r2: " + string(r2.dis))
}
draw_set_color(c_fuchsia)
if (r3.dis > 0) {
	draw_line(r3.src.x, r3.src.y, r3.dest.x, r3.dest.y)
	draw_circle(r3.dest.x, r3.dest.y, 2, false)
	draw_text(16, 72, "r3: " + string(r3.dis))
}
draw_set_color(-1)