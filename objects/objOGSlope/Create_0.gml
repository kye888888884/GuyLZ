/// @description 

function get_lines() { // return array<line>
	var lines = []
	
	var p_start = new OG.Point(0, 64)
	var p_end = new OG.Point(64, 0)
	p_start.x *= image_xscale
	p_start.y *= image_yscale
	p_start.add_dir(image_angle)
	p_end.x *= image_xscale
	p_end.y *= image_yscale
	p_end.add_dir(image_angle)
	
	var offset = new OG.Point(x, y)
	p_start.add(offset)
	p_end.add(offset)
	
	var len = 64 * (sqrt(image_xscale * image_xscale + image_yscale * image_yscale))
	for (var i = 0; i < len; i += LINE_UNIT) {
		var p1 = OG.lerp_point(p_start, p_end, i / len)
		var p2 = OG.lerp_point(p_start, p_end, min((i + LINE_UNIT) / len, 1))
		var line = new OG.Line(p1, p2)
		array_push(lines, line)
	}
	
	return lines
}
