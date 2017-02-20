extends Container

onready var menu_panel = get_node('main_panel/menu_panel')
onready var controls_panel = get_node('main_panel/controls_panel')

onready var mouse_sensitivity_slider = get_node("main_panel/controls_panel/mouse_sensitivity_slider/mouse_sensitivity_slider")
onready var free_fly_speed_slider = get_node("main_panel/controls_panel/free_fly_speed/free_fly_speed_slider")

const States = {
	"HIDDEN": 0,
	"DEFAULT": 1,
	"CONTROLS": 2
}
var state = States.HIDDEN

func _ready():
	set_process_input(true)

func _input(event):
	# react to ui_cancel (usually ESC) being pressed
	if(event.is_action_pressed("ui_cancel")):
		if( state == States.HIDDEN ):
			_on_esc_menu_enter()
		elif( state == States.CONTROLS ):
			_on_controls_menu_exit()
		elif( state == States.DEFAULT ):
			_on_esc_menu_exit()

func _on_esc_menu_enter():
	state = States.DEFAULT
	set_hidden(false)
	menu_panel.set_hidden(false)
	controls_panel.set_hidden(true)
	# pause game
	get_tree().set_pause(true)
	# show mouse
	Input.call_deferred("set_mouse_mode", Input.MOUSE_MODE_VISIBLE )

func _on_esc_menu_exit():
	state = States.HIDDEN
	set_hidden(true)
	# unpause game
	get_tree().set_pause(false)
	# capture mouse
	Input.call_deferred("set_mouse_mode", Input.MOUSE_MODE_CAPTURED )

func _on_controls_menu_enter():
	state = States.CONTROLS
	menu_panel.set_hidden(true)
	controls_panel.set_hidden(false)
	
	mouse_sensitivity_slider.set_value( player_settings.mouse_angular_speed )
	free_fly_speed_slider.set_value( player_settings.free_fly_speed )
	
func _on_controls_menu_exit():
	state = States.DEFAULT
	menu_panel.set_hidden(false)
	controls_panel.set_hidden(true)
	
	player_settings.mouse_angular_speed = mouse_sensitivity_slider.get_value()
	player_settings.free_fly_speed = free_fly_speed_slider.get_value()
	

func _on_controls_button_button_down():
	_on_controls_menu_enter()
	
func _on_resume_button_pressed():
	_on_esc_menu_exit()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_controls_back_button_pressed():
	_on_controls_menu_exit()


