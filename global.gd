extends Node

var scenes = {
	body= preload("res://world/body/body.tscn")
}

var classes = {
	chunk= preload("res://world/body/chunk.gd"),
	quad= preload("res://world/body/quad.gd")
}

const faces = {
	front = 0,
	back = 1,
	right = 2,
	left = 3,
	top = 4,
	bottom = 5,
	count = 6
}



const voxel_types = {
	empty = 0,
	blue = 1,
	green = 2,
	red = 3,
	count = 4
}
var voxel_textures = [
	null,
	preload("res://world/voxel/blue.png"),
	preload("res://world/voxel/green.png"),
	preload("res://world/voxel/red.png")
]

func _ready():
	pass