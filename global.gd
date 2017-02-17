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
	WATER = 1,
	STONE = 2,
	DIRT = 3,
	GRASS = 4,
	COUNT = 5
}

const SCENES = {
	"OCTREE_CHUNK": preload('res://world/chunk/octree_chunk.tscn')
}
const SCRIPTS = {
	"OCTREE_NODE": preload('res://world/body/octree_node.gd'),
#	"OCTREE_CHUNK": preload('res://world/chunk/octree_chunk.gd'),
	"QUAD": preload('res://utils/quad.gd'),
	"BOX": preload('res://utils/box.gd'),
	"PLAYER": preload('res://player/player.gd')
}

const MESHING_ALGORITHMS = {
	"CULLING": preload('res://algorithms/meshing_algorithms/culling.gd'),
	"GREEDY_MESHING": preload('res://algorithms/meshing_algorithms/greedy_meshing.gd')
}
const NOISE_ALGORITHMS = {
	"SIMPLEX_NOISE": preload('res://algorithms/noise_algorithms/simplex_noise.gd'),
	"FRACTAL_BROWNIAN_MOTION": preload('res://algorithms/noise_algorithms/fractal_brownian_motion.gd')
}

const BODY_INITIALIZERS = {
	"DEFAULT_INITIALIZER": preload("res://world/body/body_initializers/default_initializer.gd")
}
const CHUNK_INITIALIZERS = {
	"EMPTY_INITIALIZER": preload('res://world/chunk/chunk_initializers/empty_initializer.gd'),
	"ONE_TYPE_INITIALIZER": preload('res://world/chunk/chunk_initializers/one_type_initializer.gd'),
	"RANDOM_INITIALIZER": preload('res://world/chunk/chunk_initializers/random_initializer.gd'),
	"RANDOM_PLAIN_INITIALIZER": preload('res://world/chunk/chunk_initializers/random_plain_initializer.gd'),
	"OCTREE_UPWARD_NAIVE_INITIALIZER": preload('res://world/chunk/chunk_initializers/octree_upward_naive_initializer.gd')
}

var shape_cache = {}

func _ready():
	pass
