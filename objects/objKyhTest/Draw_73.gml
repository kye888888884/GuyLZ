/// @description Insert description here
// You can write your code in this editor

if (show_grid) {
	draw_set_color(c_gray)
	draw_set_alpha(0.2)
	for (var i = 0; i < room_width; i += grid) {
		draw_line(i, 0, i, room_height)
	}
	for (var i = 0; i < room_height; i += grid) {
		draw_line(0, i, room_width, i)
	}
	draw_set_color(-1)
	draw_set_alpha(1)
}

if (tool == 0) {
	draw_set_color(c_red)
	draw_set_alpha(0.5)
	draw_circle(mx, my, 8, false)
	draw_set_color(-1)
	draw_set_alpha(1)
}
else if (tool == 1) {
	if (select != -1) {
		var spike = spikes[select]
		draw_set_color(c_blue)
		draw_circle(mx, my, 32, false)
		draw_set_color(-1)
	}
}

draw_set_color(c_red)
draw_set_alpha(1)
array_foreach(points, function(e, i) {
	draw_set_color(c_red)
	draw_circle(e.x, e.y, 5, false)
	var n = points[(i + 1) % array_length(points)]
	draw_line(e.x, e.y, n.x, n.y)
	draw_set_color(c_gray)
	//draw_text(e.x, e.y, i)
})
draw_set_color(-1)
draw_set_alpha(1)

array_foreach(spikes, function(e, i) {
	e.draw()
})

draw_sprite(sprKyhIcon, tool, 16, 16)