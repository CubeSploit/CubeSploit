extends RigidBody

var speed = 50
var angular_speed = 0.05
var rerotation_speed = 10
var observed_force = Vector3()

onready var last_mouse_pos = get_viewport().get_mouse_pos()
onready var camera = get_node("camera")

func _ready():
	Input.call_deferred("set_mouse_mode", Input.MOUSE_MODE_CAPTURED )
	set_fixed_process(true)

func _fixed_process(delta):
	# Getting delta movement of mouse
	var current_mouse_pos = get_viewport().get_mouse_pos()
	var delta_mouse_pos =  current_mouse_pos - last_mouse_pos
	if( current_mouse_pos.distance_to(last_mouse_pos) > 1000 ):
		delta_mouse_pos = Vector2(0,0)

	last_mouse_pos = current_mouse_pos
#	print(delta_mouse_pos)
	
	var current_matrix = get_global_transform().basis
	var current_up = current_matrix.xform(Vector3(0,1,0))
	var target_up = -observed_force.normalized()
	if target_up.cross(current_up).length_squared() > 0.001:
		var new_current_matrix = fixed_rotate_matrix(current_matrix, target_up.cross(current_up), target_up.angle_to(current_up) * delta * rerotation_speed)
		var new_current_up = current_up.rotated(target_up.cross(current_up), target_up.angle_to(current_up) * delta * rerotation_speed)
#		assert(target_up.distance_to(new_current_up) < 0.1)
#		assert(target_up.distance_to(new_current_matrix.xform(Vector3(0,1,0))) < 0.1)
		current_matrix = new_current_matrix
	
	current_matrix = fixed_rotate_matrix(current_matrix, target_up, delta_mouse_pos.x * angular_speed * delta)
	
	set_global_transform(Transform(current_matrix, get_global_transform().origin))
	
	camera.rotate_x( delta_mouse_pos.y * angular_speed * delta )
#	print(get_rotation())
	
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

	# We want the player to move forward and backward to/from where it is looking at
	# Don't ask me why this does the work.
#	velocity_change = get_transform().basis * camera.get_transform().basis * velocity_change
	velocity_change = get_transform().basis * velocity_change
	
	set_linear_velocity(get_linear_velocity() + velocity_change)
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
