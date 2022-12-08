/// @description Insert description here
// You can write your code in this editor

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
    var index = 0
    for (var i = 0; i < point_number - 1; i += 2) {
        var p1 = map[i]
        var p2 = map[i + 1]
        var p3 = map[i + 2]
        var arr = make_bezier_array(p1, p2, p3, dense)
        for (var j = 0; j < dense; j++)
            result[index++] = arr[j]
    }
	return result
}

function points_to_lines(arr_points) {
    var point_number = array_length(arr_points)
    var result = array_create(point_number - 1, 0)
    for (var i = 0; i < point_number - 1; i++) {
        result[i] = new Kyh.Line(arr_points[i], arr_points[i + 1])
    }
    return result
}

function draw_polygon(arr_points, close=false) {
	var n = array_length(arr_points)
	var indexes = array_create(n + (close ? 1 : 0), 0)
	for (var i = 0; i < n + (close ? 1 : 0); i++) {
		if (i == n) {
			indexes[i] = 0
			break
		}
		indexes[i] = i
	}
	
	draw_primitive_begin(pr_trianglelist)
	while (array_length(indexes) > 2) {
		show_debug_message(indexes)
		draw_set_color(make_color_hsv(irandom(256), irandom_range(128, 256), irandom_range(128, 256)))
		var p1 = Kyh.NewPoint(arr_points[indexes[0]])
		var p2 = Kyh.NewPoint(arr_points[indexes[1]])
		var p3 = Kyh.NewPoint(arr_points[indexes[2]])
		var p12 = Kyh.NewPoint(p2)
		p12.sub(p1)
		var p13 = Kyh.NewPoint(p3)
		p13.sub(p1)
		show_debug_message("p12: (" + string(p12.x) + ", " + string(p12.y) + ")")
		show_debug_message("p13: (" + string(p13.x) + ", " + string(p13.y) + ")")
		var p12_in_line = Kyh.line_in_polygon(new Kyh.Line(p1, p2), arr_points, 10)
			|| (indexes[0] + 1 == indexes[1])
		var p13_in_line = Kyh.line_in_polygon(new Kyh.Line(p1, p3), arr_points, 10)
		if (p12.cross(p13) >= 0 && p12_in_line && p13_in_line) {
			draw_vertex(p1.x, p1.y)
			draw_vertex(p2.x, p2.y)
			draw_vertex(p3.x, p3.y)
			array_delete(indexes, 1, 1)
		}
		else {
			if (p12.cross(p13) > 0) {
				indexes[0]--
			}
			else
				array_delete(indexes, 0, 1)
		}
	}
	draw_primitive_end()
	draw_set_color(c_white)
}

// 1. Set coordinates
var coords = [[200, 100], [350, 100], [350, 300], [450, 300], [450, 100], [600, 100], [600, 500], [200, 500]]

// 2. Make points with coords
map = array_create(array_length(coords), new Kyh.Point(0, 0))
for (var i = 0; i < array_length(coords); i++)
	map[i] = new Kyh.Point(coords[i][0], coords[i][1])

// 3. Add point between each two points
map = map_divide(map)

// 4. Make bezier's curve(array of points)
bezier = map_to_bezier(map, 15, true)
bezier[array_length(bezier)] = bezier[0]

// 5. Make line with curve
lines = points_to_lines(bezier)

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

// 6+. Make background
surf_bg = surface_create(room_width, room_height)
surface_set_target(surf_bg)
draw_clear_alpha(0, 0)

draw_set_color(c_white)

draw_polygon(bezier, false)

//for (var i = 0; i < array_length(map); i++) {
//	draw_circle_color(map[i].x, map[i].y, 5, c_red, c_red, false)
//}
array_foreach(map, function(e, i) {
	draw_circle_color(e.x, e.y, 5, c_red, c_red, false)
})

surface_reset_target()

// 7. Make sprite from surface
spr = sprite_create_from_surface(surf, 0, 0, room_width, room_height, true, false, 0, 0)
sprite_index = spr

var p = new Kyh.Point(3, 4)
p.normalize()
show_debug_message(p)

function get_line(_x, _y) {
	var n = array_length(lines)
	var min_distance = 99999
	var min_index = 0
	var p = new Kyh.Point(_x, _y)
	for (var i = 0; i < n; i++) {
		var distance = lines[i].center.distance_to(p)
		if (min_distance > distance) {
			min_distance = distance
			min_index = i
		}
	}
	return lines[min_index]
}