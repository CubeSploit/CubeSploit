
static func generate_world( name, world_seed = 0 ):
	
	var world_dir = Directory.new()
	world_dir.open("user://")
	world_dir.make_dir(name)
	world_dir.change_dir(name)

#	var world_folder = File.new()
#	world_folder.open(world_dir.get_current_dir()+"/world.json", File.WRITE)

	