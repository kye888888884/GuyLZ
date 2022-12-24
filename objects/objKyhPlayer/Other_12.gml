/// @description Actions

function Jump() {
    if (meeting(0, 1.8) && !slip) {
	    // Single jump
		velocity.y = -jump
        is_jumping = true

        audio_play_sound(sndJump,0,false)
	} else if (djump > 0) {
	    // Double jump
		velocity.y = -jump2
	    sprite_index = sprPlayerJump
        is_jumping = true
        djump -= 1

        audio_play_sound(sndDJump,0,false)
	}
}
function VJump() {
    if (velocity.y < 0) {
	    velocity.y *= 0.45
	}
}
function Shoot() {
    if (instance_number(objKyhBullet) < 4) {
	    var ins = instance_create_layer(x,y-2,layer,objKyhBullet)
		ins.speed = sign(image_xscale) * 16
		ins.direction = get_grav_direction()
		ins.image_angle = ins.direction
	    audio_play_sound(sndShoot,0,false)
	}
}
function Invert() {
	if (meeting(0, 1)) {
		is_invert = !is_invert
		grav_direction.multiply(-1)
		var pos_move = pos(0, 12)
		pos_move.multiply(-2)
		x += pos_move.x
		y += pos_move.y
		move_contact(grav_direction.get_direction(), 10, objBlock)
	}
}

