static func initialize_chunk( chunk ):
	var size = chunk.size
	var iterator_range = chunk.iterator_range
	
	var raw_data = []
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
				var child = chunk.octree_node.children[child_octree_pos.x][child_octree_pos.y][child_octree_pos.z]
				var child_chunk = child.chunk
					
				# computing the starting pos of the child
				var child_start_pos = (Vector3( x % hsize, y % hsize, z % hsize) )*2
				
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
					if( block_type != global.VoxelTypes.EMPTY && block_list[block_type] > best_block_count ):
						best_block_count = block_list[block_type]
						best_block_type = block_type
				
				if( block_list.has( global.VoxelTypes.EMPTY) && block_list[global.VoxelTypes.EMPTY] > 4 ):
					raw_data[x][y][z] = global.VoxelTypes.EMPTY
				else:
					raw_data[x][y][z] = best_block_type
					
	chunk.raw_data = raw_data
		