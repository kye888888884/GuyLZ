/// @description Initialize variables

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
grav_direction = new Point(0, 1)

jump = 8.5 // Sets how fast the player jumps
jump2 = 7 // Sets how fast the player double jumps

djump = 1 // Allow the player to double jump as soon as he spawns
maxHSpeed = 3 // Max horizontal speed
maxVSpeed = 9 // Max vertical speed
velocity = new Point(0, 0)

xScale = 1 // Sets the direction the player is facing (1 is facing right, -1 is facing left)

// Set the player's hitbox depending on gravity direction
mask_index = sprPlayerMaskSlim

outsides = [270, 90, 0, 180]

function Jump() {
    if (place_meeting(x,y+1,objBlock)) {
	    // Single jump
		velocity.y = -jump
	    djump = 1
	    audio_play_sound(sndJump,0,false)
	} else if (djump == 1) {
	    // Double jump
		velocity.y = -jump2
	    sprite_index = sprPlayerJump
	    audio_play_sound(sndDJump,0,false)
    
        djump -= 0
	}
}
function VJump() {
    if (velocity.y < 0) {
	    velocity.y *= 0.45
	}
}
function Shoot() {
    if (instance_number(objBullet) < 4) {
	    instance_create_layer(x,y-2,layer,objBullet)
	    audio_play_sound(sndShoot,0,false)
	}
}

function HandleGravity() {
	if (keyboard_check(ord("A")))
		grav_direction.add_dir(1)
	velocity.x += grav_direction.x * grav_force
	velocity.y += grav_direction.y * grav_force
	image_angle = grav_direction.get_direction() - 270
}
function HandleMove() {
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

	// Vine checks
	var notOnBlock = (place_free(x,y+1))

	if (h != 0) { // Player is moving
	    xScale = h
	
		if ((h == -1) || (h == 1)) { // Make sure we're not moving off a vine (that's handled later)
	        velocity.x = maxHSpeed * h
		}
	} else { // Player is not moving
	    velocity.x = 0
	}

    var spd = new Point(velocity.x, velocity.y)
    spd.add_dir(grav_direction.get_direction() - 270)
    hspeed = spd.x
    vspeed = spd.y
}
function HandleMoveEnd() {
	//x += velocity.x
    //y += velocity.y
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
	}
}

function HandleSprite() {
	var notOnBlock = (place_free(x,y+1))
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

function HandleCollisionWithBlock() {
	// Check for horizontal collisions
	if (!place_free(x+hspeed,y)) {
		if (hspeed <= 0) {
			move_contact_solid(180,abs(hspeed))
		} else {
			move_contact_solid(0,abs(hspeed))
		}
        hspeed = 0
		velocity.x = 0
	}

	// Check for vertical collisions
	if (!place_free(x,y+vspeed)) {
		if(vspeed <= 0) {
			move_contact_solid(90,abs(vspeed))
		} else {
			move_contact_solid(270,abs(vspeed))
			djump = 1
		}
        vspeed = 0
		velocity.y = 0
	}

	// Check for diagonal collisions
	if (!place_free(x+hspeed,y+vspeed)) {
        vspeed = 0
		velocity.y = 0
	}
}
