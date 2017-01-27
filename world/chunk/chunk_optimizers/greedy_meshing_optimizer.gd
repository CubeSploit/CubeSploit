static func optimize(chunk, voxel_material):

	var chunk_size = chunk.size
	var chunk_data = chunk.raw_data
	var iterator_range = range(chunk_size)
	
	# Create and initialize the surfacetool and other handy variables
	var st = SurfaceTool.new()
	st.begin(VisualServer.PRIMITIVE_TRIANGLES)
	st.set_material( voxel_material )
	var idx = 0

	# Create a two dimensional array of quads, will contain all the raw quads of a given face before they are optimized
	var quads = []
	quads.resize(chunk_size)
	for x in iterator_range:
		quads[x] = []
		quads[x].resize(chunk_size)

	# A list of quads, will contain the final quads that will be displayed
	var to_display_quads

	# The following code is duplicated for every face
	# Currently it doesn't consume lot of ram at once, but things could be done in a smarter way
	
	# Front
	# For each layer of the front face
	for z in iterator_range:
		# For each slot of the front face
		for x in iterator_range:
			for y in iterator_range:
				# If the slot isn't empty and the neighbour slot in front of it isn't full
				if( chunk_data[x][y][z] != global.VoxelTypes.EMPTY && chunk.get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.FRONT) == global.VoxelTypes.EMPTY ):
					# Register the quad
					quads[x][y] = global.SCRIPTS.QUAD.new(chunk_data[x][y][z], Vector3(x,y,z),global.Faces.FRONT, x, y, 1, 1)
				else:
					quads[x][y] = null
		# Optimize the quads with greedy meshing
		to_display_quads = greedy_mesh_surface(quads, chunk_size)
		# For each quads in the list of quads to display
		for quad in to_display_quads:
			# Add quad to surface tool
			idx = quad.add_to_surface(st, idx)

	# Back
	for z in iterator_range:
		for x in iterator_range:
			for y in iterator_range:
				if( chunk_data[x][y][z] != global.VoxelTypes.EMPTY && chunk.get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.BACK) == global.VoxelTypes.EMPTY ):
					quads[x][y] = global.SCRIPTS.QUAD.new(chunk_data[x][y][z], Vector3(x,y,z), global.Faces.BACK, x, y, 1, 1)
				else:
					quads[x][y] = null

		to_display_quads = greedy_mesh_surface(quads, chunk_size)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx)

	# Right
	for x in iterator_range:
		for z in iterator_range:
			for y in iterator_range:
				if( chunk_data[x][y][z] != global.VoxelTypes.EMPTY && chunk.get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.RIGHT) == global.VoxelTypes.EMPTY ):
					quads[z][y] = global.SCRIPTS.QUAD.new(chunk_data[x][y][z], Vector3(x,y,z), global.Faces.RIGHT, z, y, 1, 1)
				else:
					quads[z][y] = null

		to_display_quads = greedy_mesh_surface(quads, chunk_size)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx)

	# Left
	for x in iterator_range:
		for z in iterator_range:
			for y in iterator_range:
				if( chunk_data[x][y][z] != global.VoxelTypes.EMPTY && chunk.get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.LEFT) == global.VoxelTypes.EMPTY ):
					quads[z][y] = global.SCRIPTS.QUAD.new(chunk_data[x][y][z], Vector3(x,y,z), global.Faces.LEFT, z, y, 1, 1)
				else:
					quads[z][y] = null

		to_display_quads = greedy_mesh_surface(quads, chunk_size)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx)

	# Top
	for y in iterator_range:
		for x in iterator_range:
			for z in iterator_range:
				if( chunk_data[x][y][z] != global.VoxelTypes.EMPTY && chunk.get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.TOP) == global.VoxelTypes.EMPTY ):
					quads[x][z] = global.SCRIPTS.QUAD.new(chunk_data[x][y][z], Vector3(x,y,z), global.Faces.TOP, x, z, 1, 1)
				else:
					quads[x][z] = null

		to_display_quads = greedy_mesh_surface(quads, chunk_size)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx)
			
	# Bottom
	for y in iterator_range:
		for x in iterator_range:
			for z in iterator_range:
				if( chunk_data[x][y][z] != global.VoxelTypes.EMPTY && chunk.get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.BOTTOM) == global.VoxelTypes.EMPTY ):
					quads[x][z] = global.SCRIPTS.QUAD.new(chunk_data[x][y][z], Vector3(x,y,z), global.Faces.BOTTOM, x, z, 1, 1)
				else:
					quads[x][z] = null

		to_display_quads = greedy_mesh_surface(quads, chunk_size)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx)

	# return the mesh
	return st.commit()



static func greedy_mesh_surface( quads, chunk_size ):
	# Quads is a two dimensional array of size chunk_size x chunk_size

	var quad
	var return_quads = []
	var x_neighbour
	var x_neighbour_range
	var y_neighbour
	var keep_scanning_rows
	var full_row
	var iterator_range = range(chunk_size)

	# For each slot of the surface
	for x in iterator_range:
		for y in iterator_range:
			# If the slot is empty, continue to next loop
			if( quads[x][y] == null):
				continue
			# If the slot has a quad

			# Remove it from the input quads and put it in the output quads
			quad = quads[x][y]
			quads[x][y] = null
			return_quads.append(quad)

			# While horizontal end is not reached and there is a neighbour slot to the right with a quad of the same type
			# Set position to the neighbour slot to the right
			x_neighbour = x+1
			while( x_neighbour < chunk_size && quads[x_neighbour][y] && quads[x_neighbour][y].type == quad.type ):
				# Remove that neighbour quad and increase the current quad's width
				quads[x_neighbour][y] = null
				quad.w += 1
				# Next neighbour slot to the right
				x_neighbour +=1

			# At this point, the slot to the right is empty or has a quad of different type, we can't expend the current quad further to the right
			
			# Set position to the neighbour row of slots to the bottom
			y_neighbour = y+1
			# This boolean will determine if we continue scanning next row, typically if we successfuly extended the current quad to the bottom we continue scanning
			keep_scanning_rows = true
			# While vertical end is not reached and we're allowed to keep scanning neighbours of the row bellow, meaning the current quad was extended to the bottom during previous loop
			while( y_neighbour < chunk_size && keep_scanning_rows  ):
				# This boolean will determine if all slot of the row bellow our current quad contains quads of the same type
				full_row = true
				# For each slot of the row bellow the current quad
				x_neighbour_range = range(x, x+quad.w)
				for x_neighbour in x_neighbour_range:
					# If one slot of the row hasn't a quad or has a quad of a different type
					if( !quads[x_neighbour][y_neighbour] || quads[x_neighbour][y_neighbour].type != quad.type ):
						# Stop the scanning and say the row is not full
						full_row = false
						break
				# If the row is full of quads of the same type, we can extend the current quad
				if( full_row ):
					# For each slot of the row bellow
					x_neighbour_range = range(x, x+quad.w)
					for x_neighbour in x_neighbour_range:
						# Remove the quad in the slot
						quads[x_neighbour][y_neighbour] = null
					# Increase the height of the current quad
					quad.h +=1
					# Set position to the next neighbour row to the bottom
					y_neighbour += 1
					# We expended the current quad, we can continue scanning neighbour rows bellow
					keep_scanning_rows = true
				# If the row is not full
				else:
					# Do not allow to scan the next line, current quad can't be expended anymore
					keep_scanning_rows = false

	return return_quads