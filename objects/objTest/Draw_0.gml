/// @description Insert description here
// You can write your code in this editor

draw_set_alpha(0.2)
array_foreach(coords, function(e, i) {
	e.draw()
})
draw_set_alpha(1)

var rot = [0, 0, 0]
if (keyboard_check(ord("Y")))
	rot[0] = 2
if (keyboard_check(ord("G")))
	rot[1] = 2
if (keyboard_check(ord("T")))
	rot[2] = 2
for (var i = 0; i < array_length(coords); i++)
	coords[i].rotate(rot[0], rot[1], rot[2])

cam_z += (keyboard_check(vk_up) - keyboard_check(vk_down))
FoV += (keyboard_check(ord("W")) - keyboard_check(ord("S")))
FoV = max(FoV, 1)
draw_text(32, 32, "Cam_z: " + string(cam_z))
draw_text(32, 64, "FoV: " + string(FoV))