/// @description Insert description here
// You can write your code in this editor

draw_self()

var p = raycast(0, 0, grav_direction.get_direction(), 500)
if (p != noone) {	
	//draw_set_color(c_blue)
	//draw_circle(p.x, p.y, 2, false)
	draw_set_color(-1)
	var line = map.get_line(p.x, p.y)
	if (line != noone) {
		var normal = line.get_normal()
		if (is_invert)
			normal.multiply(-1)
		grav_direction_to = normal
		//show_debug_message("x: " + string(normal.x) + " / y: " + string(normal.y))
	}
}