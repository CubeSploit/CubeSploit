extends RigidBody

var speed = 50
var angular_speed = 0.05
var rerotation_speed = 10
# the force environment applies on the player, usually it is gravity
var observed_force = Vector3()

onready var last_mouse_pos = get_viewport().get_mouse_pos()
onready var camera = get_node("camera")

func _ready():
	Input.call_deferred("set_mouse_mode", Input.MOUSE_MODE_CAPTURED )
	set_fixed_process(true)

func _fixed_process(delta):
	# Getting movement of mouse for this current frame
	# get mouse pos
	var current_mouse_pos = get_viewport().get_mouse_pos()
	# make difference with last mouse pos
	var delta_mouse_pos =  current_mouse_pos - last_mouse_pos
	# if difference is too big then it's a game beginning artifact, ignore it
	if( current_mouse_pos.distance_to(last_mouse_pos) > 1000 ):
		delta_mouse_pos = Vector2(0,0)
	# memorize current mouse pos
	last_mouse_pos = current_mouse_pos

	# apply rotation of the player according to mouse horizontal movements
	rotate_y( delta_mouse_pos.x * angular_speed * delta )
	# apply rotation of the camera according to mouse vertical movements
	camera.rotate_x( delta_mouse_pos.y * angular_speed * delta )
	
	# here we handle rotation of players according to gravity
	
	# get the basis of the player's transform
	var current_matrix = get_transform().basis
	# get the up vector transformed by the player's perspective
	var current_up = current_matrix.xform(Vector3(0,1,0))
	# get what should be the up vector of the player by getting the inverse of the applied gravity on the player
	var target_up = -observed_force.normalized()

	var rotation_axis = target_up.cross(current_up)
	# the cross product outputs a vector representing the axis of rotation between the two product
	# and which amplitude is the area of the triangle formed by the two vectors
	# if target_up and current_up aren't collinear
	if( rotation_axis.length() != 0 ):
		# get the angle between target_up and current_up
		var angle_to_target_up = target_up.angle_to(current_up)
		# compute the value of the rotation for this step
		var rotation_value = sign(angle_to_target_up) * delta * rerotation_speed
		# if by applying that rotation we get beyond the target angle, reset it to target angle
		if( rotation_value > angle_to_target_up ):
			rotation_value = angle_to_target_up
			
		# get the basis matrix rotated toward the target_up vector by a step
		var new_current_matrix = fixed_rotate_matrix(current_matrix, rotation_axis, rotation_value)
		# also rotate the velocity of the player, feels more natural
		set_linear_velocity(get_linear_velocity().rotated(rotation_axis, rotation_value))
		
		# set the new computed matrix as the used matrix
		set_transform(Transform(new_current_matrix, get_global_transform().origin))
	
	
	var velocity_change = Vector3()
	
	if( Input.is_action_pressed("move_forward") ):
		velocity_change.z = - speed * delta
	elif( Input.is_action_pressed("move_backward") ):
		velocity_change.z = speed * delta
		
	if( Input.is_action_pressed("move_left") ):
		velocity_change.x = - speed * delta
	elif( Input.is_action_pressed("move_right") ):
		velocity_change.x = speed * delta
		
	if( Input.is_action_pressed("jump") ):
		velocity_change.y = speed * delta
	elif( Input.is_action_pressed("crouch") ):
		velocity_change.y = - speed * delta

	if( observed_force.length() == 0 ):
		# We want the player to move forward and backward to/from where it is looking at
		# So the velicoty change is applied on the camera basis, and then on the player's basis
		velocity_change = get_transform().basis.xform(camera.get_transform().basis.xform(velocity_change))
	else:
		# When under gravity, the player isn't moving forward and backward where he is looking at
		# but he's moving forward and backward according to its basis
		velocity_change = get_transform().basis.xform(velocity_change)
	
	# apply the velocity changes
	set_linear_velocity(get_linear_velocity() + velocity_change)
	
	# reset the observed forces
	observed_force = Vector3()

func apply_impulse(pos, impulse):
	.apply_impulse(pos, impulse)
	observed_force += impulse

func fixed_rotate_matrix(matrix, axis, angle):
	return Matrix3(
		matrix.x.rotated(axis, angle),
		matrix.y.rotated(axis, angle),
		matrix.z.rotated(axis, angle)
	)
