/// @description Insert description here
// You can write your code in this editor

points = []
spikes = []
show_grid = true
grid = 16

mx = 0
my = 0

select = -1
tool = 0

function Spike(_x, _y, _angle) constructor {
	x = _x
	y = _y
	angle = _angle
	function draw() {
		draw_sprite_ext(sprKyhSpike, 0, x, y, 1, 1, angle, c_white, 1)
	}
}