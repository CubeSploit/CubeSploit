extends Spatial

export(PackedScene) var BodyScene


func _ready():
	var body = BodyScene.instance()
	add_child(body)
	body.set_translation(Vector3(0,0,0))
	# look good with body size 64, 16 but took 150 sec to generate
	body.init( 16, 8 )
