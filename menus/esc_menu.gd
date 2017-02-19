extends Container

func _ready():
	set_process_input(true)

func _input(event):
	# react to ui_cancel (usually ESC) being pressed
	if(event.is_action_pressed("ui_cancel")):
		# switch visibility
		set_hidden(!is_hidden())
		if(is_hidden()):
			# apply settings and hand controls back to game
			get_parent().angular_speed=get_node("HSlider").get_value()
			get_tree().set_pause(false)
			Input.call_deferred("set_mouse_mode", Input.MOUSE_MODE_CAPTURED )
		else:
			# pause game
			get_tree().set_pause(true)
			Input.call_deferred("set_mouse_mode", Input.MOUSE_MODE_VISIBLE )
