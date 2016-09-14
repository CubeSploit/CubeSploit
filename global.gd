extends Node

const scenes = {
	body= preload("res://world/body/body.tscn")
}

const classes = {
	chunk= preload("res://world/body/chunk.gd"),
	quad= preload("res://world/body/quad.gd")
}

const Faces = {
	FRONT = 0,
	BACK = 1,
	RIGHT = 2,
	LEFT = 3,
	TOP = 4,
	BOTTOM = 5,
	COUNT = 6
}



const Voxel_Types = {
	EMPTY = 0,
	BLUE = 1,
	GREEN = 2,
	RED = 3,
	COUNT = 4
}
const voxel_textures = [
	null,
	preload("res://world/voxel/blue.png"),
	preload("res://world/voxel/green.png"),
	preload("res://world/voxel/red.png")
]

func _ready():
	pass