extends Node

const player_settings_path = "user://player_settings.json"

var mouse_angular_speed = 0.05
var free_fly_speed = 50

func _ready():
	var player_settings_file = File.new()
	# if file doesn't exist
	if ( !player_settings_file.file_exists(player_settings_path) ):
		# create it and save the player settings
		save_settings()
	else:
		# else load them from the existing file
		load_settings()
		
	player_settings_file.close()
		
func save_settings():
	# open file and empties it
	var player_settings_file = File.new()
	player_settings_file.open(player_settings_path, File.WRITE)
	# reshape data in a dictionnary
	var data = {
		game_version=global.game_version, # might be useful when dealing with changes
		mouse_angular_speed=mouse_angular_speed,
		free_fly_speed=free_fly_speed
	}
	# write data in json format in the file
	player_settings_file.store_line(data.to_json())
	player_settings_file.close()

func load_settings():
	# open file in read mode
	var player_settings_file = File.new()
	player_settings_file.open(player_settings_path, File.READ)
	# get the data in a dictionnary
	var data = {}
	data.parse_json(player_settings_file.get_line())
	# set the object's attributes according to read data
	for key in data:
		if( get(key) ):
			self[key] = data[key]
			
	player_settings_file.close()

func _exit_tree():
	save_settings()