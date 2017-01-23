extends MeshInstance

var pos = Vector3(0,0,0)
var size = 32
var raw_data = [] # size * sixe * sixe 3D array
var body = null # Ref of the parent node
var iterator_range # Optimization, would have to be removed when real iterators come

func _init(body, size):
	self.body = body
	self.size = size
	iterator_range = range(size) # Optimization, would have to be removed when real iterators come

func generate_random( ):
	raw_data = []
	raw_data.resize(size)
	
	for x in iterator_range:
		raw_data[x] = []
		raw_data[x].resize(size)
		for y in iterator_range:
			raw_data[x][y] = []
			raw_data[x][y].resize(size)
			for z in iterator_range:
				raw_data[x][y][z] = (randi()%(global.VoxelTypes.COUNT-1))+1
#				raw_data[x][y][z] = randi()%global.VoxelTypes.COUNT
#				raw_data[x][y][z] = 1


func get_neighbour_voxel_type ( current_voxel, direction ):
	var neighbour_voxel = current_voxel + global.FaceDirections[direction]
	if( neighbour_voxel[neighbour_voxel.min_axis()] < 0 || neighbour_voxel[neighbour_voxel.max_axis()] >= size ):
		return global.VoxelTypes.EMPTY
	return raw_data[neighbour_voxel.x][neighbour_voxel.y][neighbour_voxel.z]

func generate_mesh( voxel_material ):
	set_mesh( global.CHUNK_OPTIMIZERS.GREEDY_MESHING_OPTIMIZER.optimize( self, voxel_material ) )





