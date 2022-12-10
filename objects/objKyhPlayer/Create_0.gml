/// @description Initialize variables

event_user(0)

#region Remove this please when import your project
#macro DIRECTIONAL_TAP_FIX false
room_speed = 50
global.leftButton = vk_left
global.rightButton = vk_right
global.jumpButton = vk_shift
global.shootButton = ord("Z")
function scrButtonCheck(key) {
    return keyboard_check(key)
}
function scrButtonCheckPressed(key) {
    return keyboard_check_pressed(key)
}
function scrButtonCheckReleased(key) {
    return keyboard_check_released(key)
}
#endregion

frozen = false // Sets if the player can move or not

grav_force = 0.446
grav_direction = new Kyh.Point(0, 1)
grav_direction_to = new Kyh.Point(0, 1)

jump = 8.5 // Sets how fast the player jumps
jump2 = 7 // Sets how fast the player double jumps
is_jumping = false

djump = 1 // Allow the player to double jump as soon as he spawns
maxHSpeed = 3 // Max horizontal speed
maxVSpeed = 9 // Max vertical speed
velocity = new Kyh.Point(0, 0)

is_invert = false

xScale = 1 // Sets the direction the player is facing (1 is facing right, -1 is facing left)

// Set the player's hitbox depending on gravity direction
mask_index = sprPlayerMask

// Create map
map = instance_create_depth(0, 0, 0, objMap)

// Custom functions
function get_grav_direction() {
	return grav_direction.get_direction() - 270
}
function move_outside(dir, dis, obj, move_anyway=false) {
	var cur = 0
	var xx, yy
	while (cur <= dis) {
		xx = x + lengthdir_x(cur, dir)
		yy = y + lengthdir_y(cur, dir)
			
		if (!place_meeting(xx, yy, obj)) {
			x = xx
			y = yy
			cur = dis
		}
		
		cur++
	}
	if (move_anyway) {
		x = xx
		y = yy
	}
}
function move_contact(dir, dis, obj, move_anyway=false) {
	var cur = 0
	var xx, yy
	while (cur <= dis) {
		xx = x + lengthdir_x(cur, dir)
		yy = y + lengthdir_y(cur, dir)
			
		if (place_meeting(xx, yy, obj)) {
			cur--
			x = x + lengthdir_x(cur, dir)
			y = y + lengthdir_y(cur, dir)
			cur = dis
		}
		
		cur++
	}
	if (move_anyway) {
		x = xx
		y = yy
	}
}
function pos(_x, _y) {
	var p = new Kyh.Point(_x, _y)
	p.add_dir(get_grav_direction())
	return p
}
function add_pos(_x, _y) {
    x += pos(_x, _y).x
    y += pos(_x, _y).y
}
function raycast(offset_x, offset_y, dir, len=500) {
	var src_x = floor(x) + pos(offset_x, offset_y).x
	var src_y = floor(y) + pos(offset_x, offset_y).y
	var dest_x
	var dest_y
	
	var is_start = true
	var is_over = false
	
	var gap = len
	
	while (true) {
		dest_x = src_x + lengthdir_x(len, dir)
		dest_y = src_y + lengthdir_y(len, dir)
		var col = collision_line(src_x, src_y, dest_x, dest_y, objBlock, true, false)
		
		gap = gap / 2
		if (gap < 0.5)
			break
		if (col == noone) {
			if (is_start)
				return noone
			is_over = false
			len += gap
		}
		else {
			is_over = true
			len -= gap
		}
		is_start = false
	}
	return new Kyh.Point(dest_x, dest_y)
}
function meeting(add_x, add_y) {
	return place_meeting(x+pos(add_x, add_y).x, y+pos(add_x, add_y).y, objBlock)
}

// Actions
function Jump() {
    if (meeting(0, 1.5)) {
	    // Single jump
		velocity.y = -jump
        //add_pos(0, -1)
        is_jumping = true
        djump = 1

        audio_play_sound(sndJump,0,false)
	} else if (djump == 1) {
	    // Double jump
		velocity.y = -jump2
	    sprite_index = sprPlayerJump
        is_jumping = true
        djump -= 0

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
		var pos_move = pos(0, 8)
		pos_move.multiply(-2)
		x += pos_move.x
		y += pos_move.y
	}
}

// Handle player
function HandleGravity() {
	grav_direction = Kyh.lerp_point(grav_direction, grav_direction_to, 0.4)
	velocity.y += grav_force
	image_angle = get_grav_direction()
}
function HandleMaxSpeed() {
	// Check if moving faster vertically than max speed
	if (abs(velocity.y) > maxVSpeed) {
		velocity.y = sign(velocity.y) * maxVSpeed
	}
}
function HandleActions() {
	// Check buttons for player actions
	if (!frozen) { // Check if frozen before doing anything
	    if (scrButtonCheckPressed(global.jumpButton)) {
	        Jump()
		}
	    if (scrButtonCheckReleased(global.jumpButton)) {
	        VJump()
		}
	    if (scrButtonCheckPressed(global.shootButton)) {
	        Shoot()
		}
		if (keyboard_check_pressed(vk_space)) {
			Invert()
		}
	}
}
function HandleMove() {
	HandleGravity()

	// Check left/right button presses
	var L = (scrButtonCheck(global.leftButton) || (DIRECTIONAL_TAP_FIX and scrButtonCheckPressed(global.leftButton)))
	var R = (scrButtonCheck(global.rightButton) || (DIRECTIONAL_TAP_FIX and scrButtonCheckPressed(global.rightButton)))

	var h = 0 //Keeps track if the player is moving left/right

	if (!frozen) { // Don't move if frozen
	    if (R) {
	        h = 1
			image_xscale = h
	    } else if (L) {
	        h = -1
			image_xscale = h
		}
	}

	if (h != 0) { // Player is moving
	    xScale = h
	
		if ((h == -1) || (h == 1)) { // Make sure we're not moving off a vine (that's handled later)
	        velocity.x = maxHSpeed * h
		}
	} else { // Player is not moving
	    velocity.x = 0
	}

    HandleActions()
	
	var dir = grav_direction.get_direction()
	if (meeting(velocity.x, 0) && meeting(velocity.x, -maxHSpeed)) {
		if (velocity.x > 0) {
			move_contact(dir + 90, velocity.x, objBlock)
			velocity.x = 0
		}
		else if (velocity.x < 0) {
			move_contact(dir - 90, -velocity.x, objBlock)
			velocity.x = 0
		}
	}
	
	if (meeting(0, velocity.y)) {
		if (velocity.y > 0) {
			move_contact(dir, velocity.y + 1, objBlock)
			velocity.y = 0
		}
		else if (velocity.y < 0) {
			move_contact(dir + 180, -velocity.y, objBlock)
			x += pos(0, 1).x
			y += pos(0, 1).y
			velocity.y = 0
		}
	}
	
    var spd = new Kyh.Point(velocity.x, velocity.y)
    spd.add_dir(get_grav_direction())
    x += spd.x
    y += spd.y

    HandleMaxSpeed()
    HandleSlope()
}

function HandleSprite() {
	var notOnBlock = !meeting(0, 1)
	if (!notOnBlock) { // Standing on something
	    // Check if moving left/right
	    var L = (scrButtonCheck(global.leftButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.leftButton)))
	    var R = (scrButtonCheck(global.rightButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.rightButton)))
        
	    if ((L || R) && !frozen) {
	        sprite_index = sprPlayerRun
	    } else {
	        sprite_index = sprPlayerIdle
	    }
	} else { // In the air
	    if ((velocity.y) < 0) {
	        sprite_index = sprPlayerJump
	    } else {
	        sprite_index = sprPlayerFall
	    }
	}
}

function HandleSlope() {
    var dir = grav_direction.get_direction()
	
    if (meeting(0, 0)) {
		move_outside(dir + 180, maxHSpeed, objBlock)
    }
	
	if (velocity.x != 0 && meeting(0, maxHSpeed + 1)) {
		move_contact(dir, maxHSpeed + 1, objBlock)
	}
	
        
}

function HandleDebug() {
	if (keyboard_check(vk_tab)) {
	    x = mouse_x
	    y = mouse_y
	}
	if (keyboard_check(ord("A")))
		grav_direction.add_dir(2)
    if (keyboard_check(ord("D")))
		grav_direction.add_dir(-2)
}