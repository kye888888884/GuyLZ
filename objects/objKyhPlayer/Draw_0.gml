/// @description Insert description here
// You can write your code in this editor

draw_self()

draw_set_color(c_blue)
if (r1 != noone)
	draw_circle(r1.x, r1.y, 2, false)
if (r2 != noone)
	draw_circle(r2.x, r2.y, 2, false)
draw_set_color(-1)
if (r1 != noone && r2 != noone && r3 != noone) {
	if (r1.distance_to(r2) > 32)
		return;
	var line = map.get_line(r3.x, r3.y)
	if (line != noone) {
		var normal = line.get_normal()
		if (is_invert)
			normal.multiply(-1)
		grav_direction_to = normal
		show_debug_message("x: " + string(normal.x) + " / y: " + string(normal.y))
	}
}