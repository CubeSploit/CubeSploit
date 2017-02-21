

static func initialize_chunk( body, chunk ):
	var octree_pos = chunk.octree_node.octree_pos
	var chunk_size = chunk.size
	var iterator_range = range(chunk_size)
	# the radius of the body is the ground level
	var body_radius = body.body_size/2
	# the maximum height generated blocks can achieve
	var body_max_radius = body_radius + body_radius/2
	var chunk_min_axis_val = octree_pos[octree_pos.min_axis()] * chunk_size
	var chunk_max_axis_val = octree_pos[octree_pos.max_axis()] * (chunk_size) + chunk_size

	# any chunk which extrema's coordinates aren't included in the body's max radius aren't going to contain anything, stop the function
	if( (chunk_min_axis_val < -body_max_radius || chunk_min_axis_val >= body_max_radius) &&
		( chunk_max_axis_val < -body_max_radius || chunk_max_axis_val >= body_max_radius) &&
		!( chunk_min_axis_val < -body_max_radius && chunk_max_axis_val >= body_max_radius )):
		return
		
	# will contain the raw data of the chunk
	var raw_data = []
	raw_data.resize(chunk_size)


	# function reference to the noise function that will be used to generate height map
	var noise_f = funcref( global.NOISE_ALGORITHMS.SIMPLEX_NOISE, "simplex_noise" )
	# the coordinates of the chunk according to the body
	var chunk_coords = octree_pos*chunk_size
	for x in iterator_range:
		raw_data[x] = []
		raw_data[x].resize(chunk_size)
		for y in iterator_range:
			raw_data[x][y] = []
			raw_data[x][y].resize(chunk_size)
			for z in iterator_range:
				# the coordinates of the voxel according to the body
				var coords = Vector3(x,y,z) + chunk_coords
				
				# the coordinates of the ground according to that voxel
				# TODO collisions for blocks under the body level at the edges and corners
				var ground_coords = Vector3(coords)
				if( ground_coords.x >= body_radius ):
					ground_coords.x = body_radius-1
				elif( ground_coords.x < -body_radius ):
					ground_coords.x = -body_radius
				if( ground_coords.y >= body_radius ):
					ground_coords.y = body_radius-1
				elif( ground_coords.y < -body_radius ):
					ground_coords.y = -body_radius
				if( ground_coords.z >= body_radius ):
					ground_coords.z = body_radius-1
				elif( ground_coords.z < -body_radius ):
					ground_coords.z = -body_radius

				if( ground_coords[coords.max_axis()]+1 >= abs(ground_coords[coords.min_axis()]) ):
					ground_coords[coords.max_axis()] = body_radius-1
				else:
					ground_coords[coords.min_axis()] = -body_radius


				# get the noise for that ground level
				# TODO singleton handling already computed values per coordinates, because several voxel will have the same ground coords
				var freq = 0.01
#				var noise = global.NOISE_ALGORITHMS.FRACTAL_BROWNIAN_MOTION.sum_octave(1, 0.5, freq, noise_f, [ground_coords.x, ground_coords.y, ground_coords.z], [0,1])
				var noise = global.NOISE_ALGORITHMS.SIMPLEX_NOISE.simplex_noise([ground_coords.x*freq, ground_coords.y*freq, ground_coords.z*freq])
				# the generated height for that ground coordinate
				var height = round(noise * body_radius) + body_radius
				
				# current height of voxel
				var current_height
				if( coords[coords.max_axis()]+1 >= abs(coords[coords.min_axis()]) ):
					current_height = coords[coords.max_axis()]+1
				else:
					current_height = abs(coords[coords.min_axis()])
				
				# if voxel is beyond the goal height, voxel is set empty
				if( current_height > height ):
					raw_data[x][y][z] = global.VoxelTypes.EMPTY
				# if voxel is at height level, set it as grass
				elif( current_height == height):
					raw_data[x][y][z] = global.VoxelTypes.GRASS
				# if voxel is under 3 steps under height level, set it as dirt
				elif( current_height > height -3):
					raw_data[x][y][z] = global.VoxelTypes.DIRT
				# anything deeper is stone type
				else:
					raw_data[x][y][z] = global.VoxelTypes.STONE

	chunk.raw_data = raw_data
	chunk.initialized = true
