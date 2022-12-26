/// @description Initialize variables

// Define
#macro PLAYER_SIZE 10 // Width of player
#macro CAN_CLIMB 1 // Slope of the block that player can climb to the maximum
#macro MIN_SLIP_DOT 0.70 // minimum of dot value to make player to slip. 0.71 is slightly smaller than cos(45˚)
#macro MIN_LEAN_DOT 0.85 // minimum of dot value to make player to lean. 0.85 ~= cos(30˚)
#macro MIN_FLOOR_DISTANCE 180

// Load global library 
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

// Properties
frozen = false // Sets if the player can move or not

grav_force = 0.446
grav_direction = new OG.Point(0, 1)
grav_direction_to = new OG.Point(0, 1)

jump = 8.5 // Sets how fast the player jumps
jump2 = 7 // Sets how fast the player double jumps
is_jumping = false

djump = 1 // Allow the player to double jump as soon as he spawns
maxHSpeed = 3 // Max horizontal speed
maxVSpeed = 9 // Max vertical speed
velocity = new OG.Point(0, 0)

is_invert = false

xScale = 1 // Sets the direction the player is facing (1 is facing right, -1 is facing left)

// Set the player's hitbox depending on gravity direction
mask_index = sprPlayerMask

// Create map
//map = instance_create_depth(0, 0, 0, objMap)

// For changing gravity
r1 = noone
r2 = noone
r3 = noone
floor_distance = 0

// For sliping
slip = false

// Load local library
event_user(1)
// Load actions
event_user(2)

// Handle player
function Step() {
	HandleMovement()

	slip = false
	HandleGravityDirection()
	HandleGravity()
	if (slip)
		show_debug_message("slip" + string(irandom(100)))
	
	HandleCollisionWithBlock()
	HandleMaxSpeed()
	HandlePosition()
    HandleSlope()
	
	HandleActions()
	HandleSprite()
}

function HandleMovement() {
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
	
	if (meeting(0, 1) && !slip)
		djump = 1
}
function HandleGravityDirection() {
	var ray_dir = grav_direction.get_direction()
	var W = PLAYER_SIZE / 2
	r1 = raycast(-W, 8, ray_dir, MIN_FLOOR_DISTANCE)
	r2 = raycast(W, 8, ray_dir, MIN_FLOOR_DISTANCE)
	r3 = raycast(0, 8, ray_dir, MIN_FLOOR_DISTANCE)
	if (r1 != noone && r2 != noone && r3 != noone) {
		var dis = r1.dest.distance_on_direction(r2.dest, grav_direction)
		
		show_debug_message("dis1: " + string(r1.dis))
		show_debug_message("dis2: " + string(r2.dis))
		show_debug_message("dis3: " + string(r3.dis))
		
		var nearst_line = noone;
		if (abs(r1.dis - r3.dis) < 1 && abs(r2.dis - r3.dis) < 1)
			nearst_line = objOGManager.get_nearst_line(r3.dest.x, r3.dest.y)
		else if (r1.dis < r2.dis)
			nearst_line = objOGManager.get_nearst_line(r1.dest.x, r1.dest.y)
		else
			nearst_line = objOGManager.get_nearst_line(r2.dest.x, r2.dest.y)
		
		if (nearst_line == noone)
			return;
			
		floor_distance = max(r1.dis, r2.dis, r3.dis)
		
		var normal, lean_dot
		if (nearst_line != noone) {
			var normal = nearst_line.get_normal()
			floor_direction = normal.cross(grav_direction)
			
			lean_dot = normal.dot(grav_direction)
			if (lean_dot < 0) {
				lean_dot *= -1
				normal.multiply(-1)
				floor_direction *= -1
			}
			show_debug_message("lean: " + string(lean_dot))
		}
		
		if (nearst_line != noone) {
			if (lean_dot < MIN_SLIP_DOT) {
				slip = true
				return;
			}
			
			if (dis < 1)
				return;
		
			if (r1.dis + 1 < r3.dis && r2.dis + 1 < r3.dis) 
				return;
			
			if (lean_dot < MIN_LEAN_DOT)
				return;
			
			grav_direction_to = normal
			return;
		}
	}
}
function HandleGravity() {
	grav_direction = OG.lerp_point(grav_direction, grav_direction_to, 0.3)
	velocity.y += grav_force
	image_angle = get_grav_direction()
}
function HandleCollisionWithBlock() {
	var dir = grav_direction.get_direction()
	if (meeting(velocity.x, 0) && meeting(velocity.x, -maxHSpeed * CAN_CLIMB)) {
		if (velocity.x > 0) {
			move_contact(dir + 90, velocity.x, objOGBlock)
			velocity.x = 0
		}
		else if (velocity.x < 0) {
			move_contact(dir - 90, -velocity.x, objOGBlock)
			velocity.x = 0
		}
	}
	
	if (meeting(0, velocity.y)) {
		if (velocity.y > 0) {
			if (!slip) {
				move_contact(dir, velocity.y + 1, objOGBlock)
				velocity.y = 0
			}
		}
		else if (velocity.y < 0) {
			move_outside(dir, -velocity.y, objOGBlock)
			velocity.y = 0
		}
	}
}
function HandleMaxSpeed() {
	// Check if moving faster vertically than max speed
	if (abs(velocity.y) > maxVSpeed) {
		velocity.y = sign(velocity.y) * maxVSpeed
	}
}
function HandlePosition() {
	var spd = new OG.Point(velocity.x, velocity.y)
	//show_debug_message("spd: (" + string(spd.x) + ", " + string(spd.y) + ")")
	spd.add_dir(get_grav_direction())
	x += spd.x
	y += spd.y
}
function HandleSlope() {
    var dir = grav_direction.get_direction()
	
	if (slip) {
		var is_floor = floor_distance < velocity.y
		//show_debug_message("floor: " + string(floor_direction))
		//show_debug_message("floor_dis: " + string(floor_distance))
		if (floor_direction < 0) { // slip to right
			if (is_floor) {
				move_outside(dir + 135, velocity.y * 1.4, objOGBlock)
				move_contact(dir - 90, velocity.y, objOGBlock)
			}
			move_outside(dir + 90, velocity.y, objOGBlock)
		}
		else {
			if (is_floor) {
				move_outside(dir - 135, velocity.y * 1.4, objOGBlock)
				move_contact(dir + 90, velocity.y, objOGBlock)
			}
			move_outside(dir - 90, velocity.y, objOGBlock)
		}
	}
	
    if (meeting(0, 0) && velocity.y >= 0) {
		move_outside(dir + 180, velocity.y + 1, objOGBlock, true)
    }
	
	if (velocity.x != 0 && meeting(0, maxHSpeed + 1)) {
		move_contact(dir, maxHSpeed + 1, objOGBlock)
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
function HandleSprite() {
	var notOnBlock = !meeting(0, 1)
	if (!notOnBlock && !slip) { // Standing on something
	    // Check if moving left/right
	    var L = (scrButtonCheck(global.leftButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.leftButton)))
	    var R = (scrButtonCheck(global.rightButton) || (DIRECTIONAL_TAP_FIX && scrButtonCheckPressed(global.rightButton)))
        
	    if ((L || R) && !frozen) {
	        sprite_index = sprPlayerRun
	    } else {
	        sprite_index = sprPlayerIdle
	    }
	} else { // In the air
	    if (velocity.y < 0) {
	        sprite_index = sprPlayerJump
	    } else {
	        sprite_index = sprPlayerFall
	    }
	}
}

function HandleDebug() {
	if (keyboard_check(vk_tab)) {
	    x = mouse_x
	    y = mouse_y
	}
	
	var add = 0
	if (keyboard_check(ord("A")))
		add = 2
    if (keyboard_check(ord("D")))
		add = -2
	
	if (add != 0) {
		grav_direction.add_dir(add)
		grav_direction_to.add_dir(add)
	}
}
