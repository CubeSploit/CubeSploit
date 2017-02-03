
static func optimize_shapes(chunk, body_rid, scale):
	var size = chunk.size
	var chunk_data = chunk.raw_data
	var iterator_range = range(size)
	
	var pos = Vector3()
	
	var shape_rid = PhysicsServer.shape_create(PhysicsServer.SHAPE_BOX)
	PhysicsServer.shape_set_data(shape_rid, Vector3(1,1,1) / 2 * scale)
	
	for x in iterator_range:
		for y in iterator_range:
			var begin = null
			for z in iterator_range:
				if chunk_data[x][y][z] != global.VoxelTypes.EMPTY and begin == null:
					begin = z
				if chunk_data[x][y][z] == global.VoxelTypes.EMPTY and begin != null:
					pos = Vector3(x + 0.5, y + 0.5, float(z + begin) / 2)
					PhysicsServer.body_add_shape(
						body_rid, create_shape(Vector3(1, 1, z - begin)),
						Transform(Matrix3(), chunk.get_translation() + pos * scale)
					)
					begin = null
			if begin != null:
				pos = Vector3(x + 0.5, y + 0.5, float(size + begin) / 2)
				PhysicsServer.body_add_shape(
					body_rid, create_shape(Vector3(1, 1, size - begin)), 
					Transform(Matrix3(), chunk.get_translation() + pos * scale)
				)

static func create_shape(size):
	if !global.shape_cache.has(size):
		var shape_rid = PhysicsServer.shape_create(PhysicsServer.SHAPE_BOX)
		PhysicsServer.shape_set_data(shape_rid, size / 2)
		global.shape_cache[size] = shape_rid
	return global.shape_cache[size]
