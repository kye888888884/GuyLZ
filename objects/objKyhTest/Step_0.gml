/// @description Insert description here
// You can write your code in this editor
mx = Kyh.stairs(mouse_x, grid, -grid * 0.5)
my = Kyh.stairs(mouse_y, grid, -grid * 0.5)

switch (tool) {
	case 0:
		if (mouse_check_button_pressed(mb_left)) {
			var idx = array_find_index(points, function(e, i) {
				return (e.x == mx) && (e.y == my)
			})
			if (idx == -1)
				array_push(points, new Kyh.Point(mx, my))
			else {
				select = idx
				if (keyboard_check(vk_control)) {
					select++
					array_insert(points, select, new Kyh.Point(mx, my))
					
				}
			}
		}
		else if (mouse_check_button(mb_left)) {
			if (select != -1) {
				points[select] = new Kyh.Point(mx, my)
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
			array_foreach(spikes, function(e, i) {
				var dis = point_distance(e.x, e.y, mx, my)
				if (min_dis > dis) {
					min_dis = dis
					min_index = i
				}
			})
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

if (keyboard_check_pressed(ord("Q")))
	tool = (tool - 1) % 3
if (keyboard_check_pressed(ord("W")))
	tool = (tool + 1) % 3

if (keyboard_check_pressed(vk_f5)) {
	if (array_length(points) >= 3)
		objMap.make_map(points)
}