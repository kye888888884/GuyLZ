/// @description Insert description here
// You can write your code in this editor

#macro LEN 5
#macro GAP 32
globalvar FoV, zoom, cam_z;
FoV = 50
zoom = 300
cam_z = 200

function Coord(_x, _y, _z) constructor {
	x = _x
	y = _y
	z = _z
	function draw() {
		var cam_width = (cam_z - z) * tan(degtorad(FoV / 2)) * 2
		if (cam_width <= 0) return;
		var scale = zoom / cam_width
		var xx = x * scale
		var yy = y * scale
		draw_circle(objTest.x + xx, objTest.y + yy, 4 * scale, false)
	}
	function rotate(_x, _y, _z) {
		// x axis
		var dir_zy = point_direction(0, 0, z, y)
		var dis_zy = point_distance(0, 0, z, y)
		z = lengthdir_x(dis_zy, dir_zy + _x)
		y = lengthdir_y(dis_zy, dir_zy + _x)
		
		// y axis
		var dir_xz = point_direction(0, 0, x, z)
		var dis_xz = point_distance(0, 0, x, z)
		x = lengthdir_x(dis_xz, dir_xz + _y)
		z = lengthdir_y(dis_xz, dir_xz + _y)
		
		// z axis
		var dir_xy = point_direction(0, 0, x, y)
		var dis_xy = point_distance(0, 0, x, y)
		x = lengthdir_x(dis_xy, dir_xy + _z)
		y = lengthdir_y(dis_xy, dir_xy + _z)
	}
}

coords = []

for (var _x= -LEN / 2 + 0.5; _x < LEN / 2; _x++) 
	for (var _y = -LEN / 2 + 0.5; _y < LEN / 2; _y++) 
		for (var _z = -LEN / 2 + 0.5; _z < LEN / 2; _z++) 
			array_push(coords, new Coord(_x * GAP, _y * GAP, _z * GAP))

show_debug_message(array_length(coords))