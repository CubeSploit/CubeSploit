extends Spatial



func _ready():
#	VS.scenario_set_debug(get_world().get_scenario(), VS.SCENARIO_DEBUG_WIREFRAME)
	var body = global.scenes.body.instance()
	add_child(body)
	body.set_translation(Vector3(0,0,0))
	body.generate_random(32)
	pass