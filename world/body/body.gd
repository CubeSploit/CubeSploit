extends Spatial

const Chunk = preload("res://world/body/chunk.gd")
const OctreeChunk = preload("res://world/body/octree_chunk.gd")
const OctreeNode = preload('res://world/body/octree_node.gd')

export(Material) var voxel_material
export(Material) var voxel_material_text

var chunk_size = 2
var chunks = [] # 3D array containing the chunks of the body


func _ready():
	pass


var octree_root
func generate_random_octree( body_size ):
	octree_root = OctreeNode.new(body_size, self)
	
	
func generate_random( size ):
	var chunk_count_per_direction = ceil( float(size) / chunk_size )

	var chunk
	chunks = []
	chunks.resize( chunk_count_per_direction )
	var iterator_range = range(chunk_count_per_direction) # Optimization, would have to be removed when real iterators come
	for x in iterator_range:
		chunks[x] = []
		chunks[x].resize(chunk_count_per_direction)
		for y in iterator_range:
			chunks[x][y] = []
			chunks[x][y].resize(chunk_count_per_direction)
			for z in iterator_range:
				chunk = Chunk.new( self, chunk_size )
				add_child(chunk)
				chunk.set_translation(Vector3(x,y,z)*chunk_size)
				chunk.generate_random()
				chunk.generate_mesh(voxel_material)
				chunks[x][y][z] = chunk



