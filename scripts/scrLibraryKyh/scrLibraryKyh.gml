Kyh = {
	step: function() {
		
	},
	
	/// @function					Point(x, y)
	Point: function (_x, _y) constructor {
		x = _x
		y = _y
		function add(point) {
			x += point.x
			y += point.y
		}
		function sub(point) {
			x -= point.x
			y -= point.y
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
		function cross(point) {
			return x * point.y - y * point.x
		}
	}
	,
	NewPoint: function (_p) {
		return new Point(_p.x, _p.y)
	}
	,
	lerp_point: function (p1, p2, weight) {
		var p = new Point(lerp(p1.x, p2.x, weight), lerp(p1.y, p2.y, weight))
	    return p
	}
	,
	/// @function					Line(point1, point2)
	Line: function (_p1, _p2) constructor {
	    p1 = _p1
	    p2 = _p2
		center = lerp_point(p1, p2, 0.5)
	    function draw(width = 3) {
	        draw_line_width(p1.x, p1.y, p2.x, p2.y, width)
	    }
		function get_normal() {
			var p = new Point(p2.x, p2.y)
			p.sub(p1)
			p.add_dir(90)
			p.normalize()
			return p
		}
	}

}
/*
function Kyh() {
	step = function() {
		
	}
	
	/// @function					Point(x, y)
	Point = function (_x, _y) constructor {
		x = _x
		y = _y
		function add(point) {
			x += point.x
			y += point.y
		}
		function sub(point) {
			x -= point.x
			y -= point.y
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
		function cross(point) {
			return x * point.y - y * point.x
		}
	}
	
	NewPoint = function (_p) {
		return new Point(_p.x, _p.y)
	}

	lerp_point = function (p1, p2, weight) {
		var p = new Point(lerp(p1.x, p2.x, weight), lerp(p1.y, p2.y, weight))
	    return p
	}
	
	/// @function					Line(point1, point2)
	Line = function (_p1, _p2) constructor {
	    p1 = _p1
	    p2 = _p2
		center = lerp_point(p1, p2, 0.5)
	    function draw(width = 3) {
	        draw_line_width(p1.x, p1.y, p2.x, p2.y, width)
	    }
		function get_normal() {
			var p = new Point(p2.x, p2.y)
			p.sub(p1)
			p.add_dir(90)
			p.normalize()
			return p
		}
	}

}
*/