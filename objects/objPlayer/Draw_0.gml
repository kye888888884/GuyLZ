/// @description Insert description here
// You can write your code in this editor

draw_self()

var p = raycast(0, 0, grav_direction.get_direction(), 500)
if (p != noone) {	
	draw_circle(p.x, p.y, 5, false)
	var line = map.get_line(p.x, p.y)
	if (line != noone) {
		var normal = line.get_normal()
		grav_direction = normal
		//show_debug_message("x: " + string(normal.x) + " / y: " + string(normal.y))
	}
}