extends Spatial

export(Material) var voxel_material
export(Material) var voxel_material_text

var chunk_size = 32
var chunks = [] # 3D array containing the chunks of the body


func _ready():
	pass



func generate_random( size ):
	var chunk_count_per_direction = ceil( float(size) / chunk_size )

	var chunk
	chunks = []
	chunks.resize( chunk_count_per_direction )
	for x in range(chunk_count_per_direction):
		chunks[x] = []
		chunks[x].resize(chunk_count_per_direction)
		for y in range(chunk_count_per_direction):
			chunks[x][y] = []
			chunks[x][y].resize(chunk_count_per_direction)
			for z in range(chunk_count_per_direction):
				chunk = global.classes.chunk.new( self, chunk_size )
				add_child(chunk)
				chunk.set_translation(Vector3(x,y,z)*chunk_size)
				chunk.generate_random()
				chunk.generate_mesh(voxel_material)
				chunks[x][y][z] = chunk



