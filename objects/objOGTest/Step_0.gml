/// @description Insert description here
// You can write your code in this editor
mx = OG.stairs(mouse_x, grid, -grid * 0.5)
my = OG.stairs(mouse_y, grid, -grid * 0.5)

switch (tool) {
	case 0:
		if (mouse_check_button_pressed(mb_left)) {
			var idx = array_find_index(points, function(e, i) {
				return (e.x == mx) && (e.y == my)
			})
			if (idx == -1)
				array_push(points, new OG.Point(mx, my))
			else {
				select = idx
				if (keyboard_check(vk_control)) {
					select++
					array_insert(points, select, new OG.Point(mx, my))
				}
			}
		}
		else if (mouse_check_button(mb_left)) {
			if (select != -1) {
				points[select] = new OG.Point(mx, my)
			}
		}
		else if (mouse_check_button_released(mb_left)) {
			select = -1
		}
		break
	case 1:
		if (mouse_check_button_pressed(mb_left)) {
			if (select == -1)
				array_push(spikes, new Spike(mx, my, 0))
		}
		if (mouse_check_button(mb_left)) {
			if (select != -1) {
				spikes[select].x = mx
				spikes[select].y = my
			}
		}
		else {
			var min_dis = 16
			var min_index = -1
			for (var i = 0; i < array_length(spikes); i++) {
				var e = spikes[i]
				var dis = point_distance(e.x, e.y, mx, my)
				if (min_dis > dis) {
					min_dis = dis
					min_index = i
				}
			}
			select = min_index
		}
		break
	case 2:
		break
}


if (mouse_check_button_pressed(mb_right)) {
	var idx = array_find_index(points, function(e, i) {
		return (e.x == mx) && (e.y == my)
	})
	if (idx != -1)
		array_delete(points, idx, 1)
}

if (keyboard_check_pressed(ord("H")))
	show_grid = !show_grid

if (keyboard_check_pressed(ord("1")))
	tool = 0
if (keyboard_check_pressed(ord("2")))
	tool = 1
if (keyboard_check_pressed(ord("3")))
	tool = 2

if (keyboard_check_pressed(vk_f5)) {
	if (array_length(points) >= 3) {
		// Write file
		var _points = ds_map_create()
		for (var i = 0; i < array_length(points); i++) {
			ds_map_add(_points, string(i), floor(points[i].x) + floor(points[i].y) * 0.001)
		}
		ds_map_secure_save(_points, "points")
		objMap.make_map(points)
	}
}

if (keyboard_check_pressed(vk_f6)) {
	var load = function() {
		if (!file_exists("points"))
			return false
		var _points = ds_map_secure_load("points")
		points = array_create(ds_map_size(_points), noone)
		for (var i = 0; i < ds_map_size(_points); i++) {
			var temp = ds_map_find_value(_points, string(i))
			show_debug_message(temp)
			var p = new OG.Point(floor(temp), frac(temp) * 1000)
			points[i] = p
		}
		return true
		
	}
	if (load())
		objMap.make_map(points)
}