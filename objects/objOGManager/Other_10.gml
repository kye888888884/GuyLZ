/// @description global library

globalvar OG;
OG = {
	// Math Functions
	stairs: function(value, step=1, offset=0) {
		return ((value - offset) div step) * step
	},
	point_in_polygon: function(p, polygon) {
		var crosses = 0
		// https://bowbowbow.tistory.com/24
		// For all lines of polygon
		for (var i = 0; i < array_length(polygon); i++) {
			var p1 = polygon[i]
			var p2 = polygon[(i + 1) % array_length(polygon)]
			// y of P is between y of P1 and y of P2
			if ((p1.y > p.y) != (p2.y > p.y)) {
				// Get point of intersection of P's right ray and segment of polygon
				var atX = (p2.x - p1.x) * (p.y - p1.y) / (p2.y - p1.y) + p1.x
				// If point of intersection is to the right of P, add 1 to the crosses
				if (p.x < atX)
					crosses++
			}
		}
		return crosses % 2 == 1
	},
	line_in_polygon: function(line, polygon, dense=5) {
		dense = max(dense, 2)
		for (var i = 1; i < dense; i++) {
			var p = OG.lerp_point(line.p1, line.p2, i / dense)
			if (!OG.point_in_polygon(p, polygon))
				return false
		}
		return true
	},
	
	// Custom Classes
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
		function equal(point) {
			return (x == point.x) && (y == point.y)
		}
		function get_length() {
			return point_distance(0, 0, x, y)
		}
		function get_direction() {
			return point_direction(0, 0, x, y)
		}
		function set(dir, len = 1) {
			x = lengthdir_x(len, dir)
			y = lengthdir_y(len, dir)
		}
		function to(dir) {
			var len = get_length()
			x = lengthdir_x(len, dir)
			y = lengthdir_y(len, dir)
		}
		function add_dir(dir) {
			to(get_direction() + dir)
		}
		function normalize() {
			var len = get_length()
			if (len == 0)
				return;
			x *= 1 / len
			y *= 1 / len
		}
		function distance_to(point) {
			return point_distance(x, y, point.x, point.y)
		}
		function distance_on_direction(_point, _dir) {
			var p = OG.NewPoint(_point)
			p.sub(new OG.Point(x, y))
			
			var dir = OG.NewPoint(_dir)
			dir.add_dir(90)
			if (dir.get_length() == 0)
				return -1
			return abs(p.cross(dir)) / dir.get_length()
		}
		function mirror(point) {
			var p = OG.NewPoint(point)
			p.multiply(2)
			p.sub(new OG.Point(x, y))
			return p
		}
		// Vector functions
		function dot(point) {
			return x * point.x + y * point.y
		}
		function cross(point) {
			return x * point.y - y * point.x
		}
	}
	,
	NewPoint: function (_p) {
		return new OG.Point(_p.x, _p.y)
	}
	,
	lerp_point: function (p1, p2, weight) {
		var p = new OG.Point(lerp(p1.x, p2.x, weight), lerp(p1.y, p2.y, weight))
		return p
	}
	,
	/// @function					Line(point1, point2)
	Line: function (_p1, _p2) constructor {
		p1 = _p1
		p2 = _p2
		center = OG.lerp_point(p1, p2, 0.5)
		function draw(width = 3) {
		    draw_line_width(p1.x, p1.y, p2.x, p2.y, width)
			draw_circle(p1.x, p1.y, width * 0.5, false)
			draw_circle(p2.x, p2.y, width * 0.5, false)
		}
		function get_direction() {
			var p = OG.NewPoint(p2)
			p.sub(p1)
			return p
		}
		function get_normal() {
			var p = OG.NewPoint(p2)
			p.sub(p1)
			p.add_dir(90)
			p.normalize()
			return p
		}
		function get_length() {
			return p1.distance_to(p2)
		}
	},
	ds_grid_add_row: function(_grid) {
		ds_grid_resize(_grid, ds_grid_width(_grid), ds_grid_height(_grid) + 1)
		return ds_grid_height(_grid) - 1
	}
}


