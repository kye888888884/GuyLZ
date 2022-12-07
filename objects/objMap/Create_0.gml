/// @description Insert description here
// You can write your code in this editor

function lerp_point(p1, p2, weight) {
	var p = new Point(lerp(p1.x, p2.x, weight), lerp(p1.y, p2.y, weight))
    return p
}

function map_divide(map) {
    var point_number = array_length(map)
    var result = array_create(point_number * 2, 0)
    for (var i = 0; i < point_number; i++) {
        var p1 = map[i]
        var p2 = lerp_point(map[i], (i < point_number - 1) ? map[i + 1] : map[0], 0.5)
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
        var p12 = lerp_point(p1, p2, w)
        var p23 = lerp_point(p2, p3, w)
        arr[i] = lerp_point(p12, p23, w)
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
    var result = array_create(line_number, new Point(0, 0))
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
        result[i] = new Line(arr_points[i], arr_points[i + 1])
    }
    return result
}

// 1. Set coordinates
var coords = [[200, 100], [300, 100], [300, 300], [500, 100], [500, 500], [100, 300]]

// 2. Make points with coords
map = array_create(array_length(coords), new Point(0, 0))
for (var i = 0; i < array_length(coords); i++)
	map[i] = new Point(coords[i][0], coords[i][1])

// 3. Add point between each two points
map = map_divide(map)

// 4. Make bezier's curve(array of points)
bezier = map_to_bezier(map, 10, true)
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
	line.draw()
}
surface_reset_target()

// 7. Make sprite from surface
spr = sprite_create_from_surface(surf, 0, 0, room_width, room_height, true, false, 0, 0)
sprite_index = spr

var p = new Point(3, 4)
p.normalize()
show_debug_message(p)