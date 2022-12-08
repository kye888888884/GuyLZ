/// @description Insert description here
// You can write your code in this editor
draw_surface(surf_bg, 0, 0)

shader_set(shaLine)
shader_set_uniform_f(sha_time, current_time / 1000)
shader_set_uniform_f(sha_value, 0.001)
shader_set_uniform_f(sha_dense, 200.0)
draw_surface(surf_fake_line, 0, 0)
shader_reset()
//draw_self()
//draw_set_color(c_gray)
//for (var i = 0; i < array_length(lines); i++) {
//    var p = lines[i]
//	p.draw()
//}
//draw_set_color(c_white)
//for (var i = 0; i < array_length(map); i++) {
//    var p = map[i]
//	draw_circle(p.x, p.y, 2, false)
//}
//draw_set_color(c_white)