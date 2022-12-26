/// @description

with(objOGPlayerStart)
	start()

for (var i = 0; i < instance_number(objOGLines); i++) {
	var ins = instance_find(objOGLines, i)
	var other_lines = ins.get_lines()
	show_debug_message(array_length(other_lines))
	lines = array_concat(lines, other_lines)
}

instance_destroy(objOGLines)

surf_lines = surface_create(room_width, room_height)
surface_set_target(surf_lines)
draw_clear_alpha(0, 0)
array_foreach(lines, function(line, i) {
	draw_set_color(make_color_hsv(irandom(256), 255, 255))
	line.draw(LINE_WIDTH)
})
draw_set_color(-1)
surface_reset_target()

sprite_index = sprite_create_from_surface(surf_lines, 0, 0, room_width, room_height, true, false, 0, 0)