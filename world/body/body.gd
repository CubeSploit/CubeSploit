extends Spatial

export(Material) var voxel_material

var chunk_size = 32
var chunks


func _ready():
	pass



func generate_random( size ):
	var chunk_count_per_direction = ceil( float(size) / chunk_size )

	chunks = []
	chunks.resize( chunk_count_per_direction )
	for x in range(chunk_count_per_direction):
		chunks[x] = []
		chunks[x].resize(chunk_count_per_direction)
		for y in range(chunk_count_per_direction):
			chunks[x][y] = []
			chunks[x][y].resize(chunk_count_per_direction)
			for z in range(chunk_count_per_direction):
				chunks[x][y][z] = global.classes.chunk.new( self, Vector3(x,y,z)*chunk_size, chunk_size )
				chunks[x][y][z].generate_random()
				chunks[x][y][z].generate_mesh(voxel_material)



