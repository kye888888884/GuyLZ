/// @description Insert description here
// You can write your code in this editor

#macro LINE_CHECK_DENSE 20
/*
  LINE_CHECK_DENSE is precision how densely lines of polygon check
  whether the line is outside of entire polygon when draw polygon.
  
  If LINE_CHECK_DENSE is 100, map generator will check it dot by dot.
  If LINE_CHECK_DENSE is 0, map generator don't check it.
*/
#macro GET_NEARST_LINE_MAX_DISTANCE 32

function map_divide(map) {
    var point_number = array_length(map)
    var result = array_create(point_number * 2, 0)
    for (var i = 0; i < point_number; i++) {
        var p1 = map[i]
        var p2 = Kyh.lerp_point(map[i], (i < point_number - 1) ? map[i + 1] : map[0], 0.5)
        result[i * 2] = p1
        result[i * 2 + 1] = p2
    }
    var temp = result[0]
    for (var i = 1; i < point_number * 2; i++)
        result[i - 1] = result[i]
    result[point_number * 2 - 1] = temp
    return result
}

function make_bezier_array(p1, p2, p3, dense=10) {
    var arr = []
    for (var i = 0; i < dense; i++) {
		var w = i / dense
        var p12 = Kyh.lerp_point(p1, p2, w)
        var p23 = Kyh.lerp_point(p2, p3, w)
        arr[i] = Kyh.lerp_point(p12, p23, w)
    }
    return arr
}

function map_to_bezier(arr_points, dense=10) {
    var point_number = array_length(arr_points)
	var map = array_create(point_number, 0)
    array_copy(map, 0, arr_points, 0, point_number)

    // Check error
    if (point_number <= 2) {
        show_error("To make points to lines, number of points must be larger than 2.", false)
        return []
    }
	
	var close = point_number % 2 == 0
    if (close) {
		map[point_number] = map[0]
		point_number++
	}

    var curve_number = floor(point_number / 2)
    var line_number = dense * curve_number
    var result = array_create(line_number, new Kyh.Point(0, 0))
	var rest = 0
    var index = 0
    for (var i = 0; i < point_number - 1; i += 2) {
        var p1 = map[i]
        var p2 = map[i + 1]
        var p3 = map[i + 2]
		var _dense = dense
		
		if (p1.equal(p2) && p1.equal(p3))
			_dense = 0
		else {
			var len = p1.distance_to(p3)
			var u = Kyh.NewPoint(p3)
			u.sub(p1)
			var PA = Kyh.NewPoint(p2)
			PA.sub(p1)
		
			var H = abs(u.cross(PA)) / u.get_length()
		
			if (H == 0 || len == 0)
				_dense = max(1, floor(len / 32))
			else
				_dense = floor(dense * (H * 0.01 + len * 0.005) + 1)
			//show_debug_message("H: " + string(H) + " / L: " + string(len))
			//show_debug_message(_dense)
		}
		
		rest += dense - _dense
		
        var arr = make_bezier_array(p1, p2, p3, _dense)
        for (var j = 0; j < _dense; j++)
            result[index++] = arr[j]
    }
	array_resize(result, line_number - rest)
	return result
}

function points_to_lines(arr_points, close=false) {
    var n = array_length(arr_points)
    var result = array_create(n - 1, 0)
    for (var i = 0; i < (close ? n : (n - 1)); i++) {
        result[i] = new Kyh.Line(arr_points[i % n], arr_points[(i + 1) % n])
    }
    return result
}

function draw_polygon(arr_points) {
	/*
	
	*/
	var n = array_length(arr_points)
	var indexes = array_create(n, 0)
	for (var i = 0; i < n; i++)
		indexes[i] = i
	
	var cur = 0
	draw_primitive_begin(pr_trianglelist)
	while (array_length(indexes) > 2) {
		//show_debug_message(indexes)
		//draw_set_color(make_color_hsv(irandom(256), 30, 255))
		draw_set_color(-1)
		var len = array_length(indexes)
		
		var p1 = Kyh.NewPoint(arr_points[indexes[cur % len]])
		var p2 = Kyh.NewPoint(arr_points[indexes[(cur + 1) % len]])
		var p3 = Kyh.NewPoint(arr_points[indexes[(cur + 2) % len]])
		var p12 = Kyh.NewPoint(p2)
		p12.sub(p1)
		var p13 = Kyh.NewPoint(p3)
		p13.sub(p1)
		
		var line12 = new Kyh.Line(p1, p2)
		var line13 = new Kyh.Line(p1, p3)
		
		var p12_in_line = (indexes[cur % len] + 1 == indexes[(cur + 1) % len]) 
			|| Kyh.line_in_polygon(line12, arr_points, line12.get_length() * (LINE_CHECK_DENSE / 100))
		var p13_in_line = (indexes[cur % len] + 1 == indexes[(cur + 2) % len]) 
			|| Kyh.line_in_polygon(line13, arr_points, line13.get_length() * (LINE_CHECK_DENSE / 100))
		
		if (p12.cross(p13) >= 0 && p12_in_line && p13_in_line) {
			draw_vertex(p1.x, p1.y)
			draw_vertex(p2.x, p2.y)
			draw_vertex(p3.x, p3.y)
			array_delete(indexes, (cur + 1) % len, 1)
		}
		else {
			if (len == 3)
				break;
			cur++
		}
	}
	draw_primitive_end()
	draw_set_color(c_white)
}

function make_map(map) {
	// 1. Set coordinates
	// coords = [[0, 0]]
		
	// 2. Make points with coords
	//map = array_create(array_length(coords), new Kyh.Point(0, 0))
	//for (var i = 0; i < array_length(coords); i++)
	//	map[i] = new Kyh.Point(coords[i][0], coords[i][1])

	// 3. Add point between each two points
	map = map_divide(map)

	// 4. Make bezier's curve(array of points)
	var bezier = map_to_bezier(map, 5)

	// 5. Make line with curve
	lines = points_to_lines(bezier, true)

	// 6. Make surface with line
	var surf = surface_create(room_width, room_height)
	surface_set_target(surf)
	draw_clear_alpha(0, 0)

	draw_set_color(c_gray)
	for (var i = 0; i < array_length(lines); i++) {
	    var line = lines[i]
		line.draw(5)
	}
	surface_reset_target()

	var surf_fake_line = surface_create(room_width, room_height)
	surface_set_target(surf_fake_line)
	draw_clear_alpha(0, 0)

	draw_set_color(0)
	for (var i = 0; i < array_length(lines); i++) {
	    var line = lines[i]
		line.draw(6)
	}
	draw_set_color(-1)
	surface_reset_target()
	spr_fake_line = sprite_create_from_surface(surf_fake_line, 0, 0, room_width, room_height, false, false, 0, 0)

	// 6+. Make background
	var surf_bg = surface_create(room_width, room_height)
	surface_set_target(surf_bg)
	draw_clear_alpha(0, 0)

	draw_set_color(c_white)

	draw_polygon(bezier)

	//for (var i = 0; i < array_length(map); i++) {
	//	draw_circle_color(map[i].x, map[i].y, 5, c_red, c_red, false)
	//}
	array_foreach(bezier, function(e, i) {
		draw_circle_color(e.x, e.y, 1, c_red, c_red, false)
	})

	surface_reset_target()
	spr_bg = sprite_create_from_surface(surf_bg, 0, 0, room_width, room_height, true, false, 0, 0)

	// 7. Make sprite from surface
	spr = sprite_create_from_surface(surf, 0, 0, room_width, room_height, true, false, 0, 0)
	sprite_index = spr
}

lines = []
spr = noone
spr_bg = noone
spr_fake_line = noone

var coords = [[100, 100],
		[300, 100], 
		[300, 300], 
		[500, 300], 
		[500, 300], 
		[500, 100], 
		[500, 100], 
		[700, 100], 
		[700, 300], 
		[700, 500], 
		[700, 500], 
		[500, 500], 
		[100, 500]]
var map = array_create(array_length(coords), new Kyh.Point(0, 0))
for (var i = 0; i < array_length(coords); i++)
	map[i] = new Kyh.Point(coords[i][0], coords[i][1])
make_map(map)

// Shader
sha_time = shader_get_uniform(shaLine, "time")
sha_value = shader_get_uniform(shaLine, "value")
sha_dense = shader_get_uniform(shaLine, "dense")

function get_nearst_line(_x, _y) {
	var n = array_length(lines)
	var min_distance = 99999
	var min_index = -1
	var p = new Kyh.Point(_x, _y)
	for (var i = 0; i < n; i++) {
		var distance = lines[i].center.distance_to(p)
		if (min_distance > distance && GET_NEARST_LINE_MAX_DISTANCE >= distance) {
			min_distance = distance
			min_index = i
		}
	}
	if (min_index < 0) {
		return noone
	}
	return lines[min_index]
}