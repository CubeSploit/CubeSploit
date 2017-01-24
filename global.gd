extends Node

const Faces = {
	FRONT = 0,
	BACK = 1,
	RIGHT = 2,
	LEFT = 3,
	TOP = 4,
	BOTTOM = 5,
	COUNT = 6
}

const FaceDirections = [
	Vector3(0,0,1), # FRONT
	Vector3(0,0,-1), # BACK
	Vector3(1,0,0), # RIGHT
	Vector3(-1,0,0), # LEFT
	Vector3(0,1,0), # TOP
	Vector3(0,-1,0) # BOTTOM
]



const VoxelTypes = {
	EMPTY = 0,
	BLUE = 1,
	GREEN = 2,
	RED = 3,
	COUNT = 4
}

const CHUNK_OPTIMIZERS = {
	"GREEDY_MESHING_OPTIMIZER": preload('res://world/body/chunk_optimizers/greedy_meshing_optimizer.gd')
}

const CHUNK_INITIALIZERS = {
	"RANDOM_INITIALIZER": preload('res://world/body/chunk_initializers/random_initializer.gd')
}


func _ready():
	pass