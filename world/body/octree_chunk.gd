extends MeshInstance

var pos = Vector3(0,0,0)
var size = 32
var raw_data = [] # size * sixe * sixe 3D array
var body = null # Ref of the parent node
var iterator_range # Optimization, would have to be removed when real iterators come

var octree_node

func _init(body):
	self.body = body
	self.size = body.chunk_size
	iterator_range = range(size) # Optimization, would have to be removed when real iterators come
	
func generate_random( ):
	global.CHUNK_INITIALIZERS.RANDOM_INITIALIZER.initialize( self )
	
func init_from_bellow( ):
	raw_data = []
	raw_data.resize(size)
	for x in iterator_range:
		raw_data[x] = []
		raw_data[x].resize(size)
		for y in iterator_range:
			raw_data[x][y] = []
			raw_data[x][y].resize(size)
			for z in iterator_range:
				var hsize = size/2
				# computing the octree child concerned
				var child_octree_pos = Vector3(0,0,0)
				if( x >= hsize ):
					child_octree_pos.x = 1
				if( y >= hsize ):
					child_octree_pos.y = 1
				if( z >= hsize ):
					child_octree_pos.z = 1
					
				# getting the child
				var child = octree_node.children[child_octree_pos.x][child_octree_pos.y][child_octree_pos.z]
				var child_chunk = child.chunk
					
				# computing the starting pos of the child
				var child_start_pos = (Vector3(x% hsize,y% hsize,z% hsize) )*2
				
				# creating table of block type count
				var block_list = {}
				
				for xc in range(2):
					for yc in range(2):
						for zc in range(2):
							var child_block_type = child_chunk.raw_data[child_start_pos.x+xc][child_start_pos.y+yc][child_start_pos.z+zc]
							if( !block_list.has( child_block_type ) ):
								block_list[child_block_type] = 0
							block_list[child_block_type] += 1
				
				var best_block_type = 0
				var best_block_count = -1
				var list_keys = block_list.keys()
				for i in range(list_keys.size()):
					var block_type = list_keys[i]
					if( block_list[block_type] > best_block_count ):
						best_block_count = block_list[block_type]
						best_block_type = block_type
				
				raw_data[x][y][z] = best_block_type
							

func get_neighbour_voxel_type ( current_voxel, direction ):
	var neighbour_voxel = current_voxel + global.FaceDirections[direction]
	if( neighbour_voxel[neighbour_voxel.min_axis()] < 0 || neighbour_voxel[neighbour_voxel.max_axis()] >= size ):
		return global.VoxelTypes.EMPTY
	return raw_data[neighbour_voxel.x][neighbour_voxel.y][neighbour_voxel.z]

func generate_mesh( voxel_material ):
	set_mesh( global.CHUNK_OPTIMIZERS.GREEDY_MESHING_OPTIMIZER.optimize( self, voxel_material ) )

