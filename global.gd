extends Node



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
	load("res://world/voxel/blue.png"),
	load("res://world/voxel/green.png"),
	load("res://world/voxel/red.png")
]

func _ready():
	pass