extends Spatial

var velocity = Vector3(0,0,0)
var speed = 50
var angular_speed = 0.05

var last_mouse_pos = Vector2(0,0)
onready var camera = get_node("camera")

func _ready():
	Input.set_mouse_mode( Input.MOUSE_MODE_CAPTURED )
	set_fixed_process(true)
	
	
func _fixed_process(delta):
	# Getting delta movement of mouse
	var current_mouse_pos = get_viewport().get_mouse_pos()
	var delta_mouse_pos =  current_mouse_pos - last_mouse_pos
	last_mouse_pos = get_viewport().get_mouse_pos()
#	print(delta_mouse_pos)
	
	rotate_y( delta_mouse_pos.x * angular_speed * delta )
	camera.rotate_x( delta_mouse_pos.y * angular_speed * delta )
#	print(get_rotation())
	
	if( Input.is_action_pressed("move_forward") ):
		velocity.z = - speed * delta
	elif( Input.is_action_pressed("move_backward") ):
		velocity.z = speed * delta
	else:
		velocity.z = 0
		
	if( Input.is_action_pressed("move_left") ):
		velocity.x = - speed * delta
	elif( Input.is_action_pressed("move_right") ):
		velocity.x = speed * delta
	else:
		velocity.x = 0
		
	if( Input.is_action_pressed("jump") ):
		velocity.y = speed * delta
	elif( Input.is_action_pressed("crouch") ):
		velocity.y = - speed * delta
	else:
		velocity.y = 0

	# We want the player to move forward and backward to/from where it is looking at
	# Don't ask me why this does the work.
	move(get_transform().basis * camera.get_transform().basis * velocity )

	
	
	