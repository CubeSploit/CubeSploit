extends Spatial



func _ready():
	var body = global.scenes.body.instance()
	add_child(body)
	body.set_translation(Vector3(0,0,0))
	body.generate_random(32)
	pass