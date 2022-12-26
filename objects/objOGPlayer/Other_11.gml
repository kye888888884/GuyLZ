/// @description local library

function get_grav_direction() {
	return grav_direction.get_direction() - 270
}
function move_outside(dir, dis, obj, move_anyway=false) {
	if (!place_meeting(x, y, obj) && !move_anyway)
		return;
	
	var cur = 0
	var xx, yy
	while (cur <= dis) {
		xx = x + lengthdir_x(cur, dir)
		yy = y + lengthdir_y(cur, dir)
			
		if (!place_meeting(xx, yy, obj)) {
			x = xx
			y = yy
			cur = dis
		}
		
		cur++
	}
	if (move_anyway) {
		x = xx
		y = yy
	}
}
function move_contact(dir, dis, obj, move_anyway=false) {
	if (place_meeting(x, y, obj) && !move_anyway)
		return;
	
	var cur = 0
	var xx, yy
	while (cur <= dis) {
		xx = x + lengthdir_x(cur, dir)
		yy = y + lengthdir_y(cur, dir)
			
		if (place_meeting(xx, yy, obj)) {
			cur--
			x = x + lengthdir_x(cur, dir)
			y = y + lengthdir_y(cur, dir)
			cur = dis
		}
		
		cur++
	}
	if (move_anyway) {
		x = xx
		y = yy
	}
}
function pos(_x, _y, _dir=0) {
	var p = new OG.Point(_x, _y)
	p.add_dir(get_grav_direction() + _dir)
	return p
}
function add_pos(_x, _y) {
    x += pos(_x, _y).x
    y += pos(_x, _y).y
}
function raycast(offset_x, offset_y, dir, len=500) {
	var src_x = floor(x) + pos(offset_x, offset_y).x
	var src_y = floor(y) + pos(offset_x, offset_y).y
	var dest_x
	var dest_y
	
	var is_start = true
	var is_over = false
	
	var gap = len
	
	while (true) {
		dest_x = src_x + lengthdir_x(len, dir)
		dest_y = src_y + lengthdir_y(len, dir)
		var col = collision_line(src_x, src_y, dest_x, dest_y, objOGBlock, true, false)
		
		gap = gap / 2
		if (gap < 0.5)
			break
		if (col == noone) {
			if (is_start)
				return noone
			is_over = false
			len += gap
		}
		else {
			is_over = true
			len -= gap
		}
		is_start = false
	}
	return {
		src: new OG.Point(src_x, src_y),
		dest: new OG.Point(dest_x, dest_y), 
		dis: point_distance(src_x, src_y, dest_x, dest_y)
	}
}
function meeting(add_x, add_y) {
	return place_meeting(x+pos(add_x, add_y).x, y+pos(add_x, add_y).y, objOGBlock)
}