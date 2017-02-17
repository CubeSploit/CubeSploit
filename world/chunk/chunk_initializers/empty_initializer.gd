static func initialize_chunk( chunk ):
	var size = chunk.size
	var iterator_range = range(size)
	var raw_data = []
	raw_data.resize(size)

	for x in iterator_range:
		raw_data[x] = []
		raw_data[x].resize(size)
		for y in iterator_range:
			raw_data[x][y] = []
			raw_data[x][y].resize(size)
			for z in iterator_range:
				raw_data[x][y][z] = global.VoxelTypes.EMPTY
				
	chunk.raw_data = raw_data
	chunk.initialized = true