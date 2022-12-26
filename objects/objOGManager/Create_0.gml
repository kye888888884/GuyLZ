/// @description

#macro LINE_WIDTH 3 // Recommend that value is larger than 2.

globalvar LINE_UNIT;
LINE_UNIT = 16

event_user(0)

x = 0
y = 0

lines = []
alarm[0] = 1

depth = -5

function get_nearst_line(_x, _y) {
	var n = array_length(lines)
	var min_distance = 99999
	var min_index = -1
	var p = new OG.Point(_x, _y)
	for (var i = 0; i < n; i++) {
		var distance = lines[i].center.distance_to(p)
		if (min_distance > distance && LINE_UNIT >= distance) {
			min_distance = distance
			min_index = i
		}
	}
	if (min_index < 0) {
		return noone
	}
	return lines[min_index]
}