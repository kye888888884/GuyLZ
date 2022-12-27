/// @description

#macro LINE_WIDTH 3 // Recommend that value is larger than 2.

globalvar LINE_UNIT; // Dense of line segments
LINE_UNIT = 16

event_user(0)

x = 0
y = 0

lines = []
alarm[0] = 1

depth = -5


function update() {
	surf_lines = surface_create(room_width, room_height)
	surface_set_target(surf_lines)
	draw_clear_alpha(0, 0)
	draw_set_alpha(1)
	array_foreach(lines, function(line, i) {
		//draw_set_color(make_color_hsv(irandom(256), 255, 255))
		draw_set_color(c_red)
		line.draw(LINE_WIDTH)
	})
	draw_set_color(-1)
	surface_reset_target()

	sprite_index = sprite_create_from_surface(surf_lines, 0, 0, room_width, room_height, true, false, 0, 0)
}

function get_nearst_line(_x, _y) {
	var n = array_length(lines)
	var min_distance = 99999
	var min_index = -1
	var p = new OG.Point(_x, _y)
	for (var i = 0; i < n; i++) {
		var distance = lines[i].center.distance_to(p)
		if (min_distance > distance && LINE_UNIT >= distance) {
			min_distance = distance
			min_index = i
		}
	}
	if (min_index < 0) {
		return noone
	}
	return lines[min_index]
}