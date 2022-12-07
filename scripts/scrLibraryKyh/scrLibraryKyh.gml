/// @function					Point(x, y)
function Point(_x, _y) constructor {
	x = _x
	y = _y
	function add(point) {
		x += f
		y += f
	}
	function multiply(f) {
		x *= f
		y *= f
	}
	function length() {
		return sqrt(x * x + y * y)
	}
	function get_direction() {
		return point_direction(0, 0, x, y)
	}
	function set(dir, len = 1) {
		x = lengthdir_x(len, dir)
		y = lengthdir_y(len, dir)
	}
	function to(dir) {
		var len = length()
		x = lengthdir_x(len, dir)
		y = lengthdir_y(len, dir)
	}
	function add_dir(dir) {
		to(get_direction() + dir)
	}
	function normalize() {
		var len = length()
		if (len == 0)
			return;
		x *= 1 / len
		y *= 1 / len
	}
	function distance_to(point) {
		return point_distance(x, y, point.x, point.y)
	}
	function dot(point) {
		return x * point.x + y * point.y
	}
}

/// @function					Line(point1, point2)
function Line(_p1, _p2) constructor {
    p1 = _p1
    p2 = _p2
    function draw(width = 3) {
        draw_line_width(p1.x, p1.y, p2.x, p2.y, width)
    }
}
