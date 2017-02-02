extends Spatial

export(PackedScene) var BodyScene


func _ready():

	var body = BodyScene.instance()
	add_child(body)
	body.set_translation(Vector3(0,0,0))
	body.generate_random_octree( 16 )