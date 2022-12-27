/// @description 

function get_lines() {
	var lines = []
	
	var pos = new OG.Point(x, y)
	var offset = new OG.Point(-image_xscale + 1, -image_yscale + 1)
	offset.add_dir(image_angle)
	
	pos.add(offset)
	
	var unit = 90 / (LINE_UNIT * sqrt(image_xscale) * sqrt(image_yscale))
	for (var i = 0; i < 90; i += unit) {
		var dir = 90 + i
		var dir2 = min(180, dir + unit)
		var p1 = new OG.Point(lengthdir_x(64 * image_xscale, dir), lengthdir_y(64 * image_yscale, dir))
		var p2 = new OG.Point(lengthdir_x(64 * image_xscale, dir2), lengthdir_y(64 * image_yscale, dir2))
		
		p1.add_dir(image_angle)
		p2.add_dir(image_angle)
		
		p1.add(pos)
		p2.add(pos)
		
		var line = new OG.Line(p1, p2)
		array_push(lines, line)
	}
	
	return lines
}