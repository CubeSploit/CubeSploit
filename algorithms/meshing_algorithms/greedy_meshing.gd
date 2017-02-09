
static func greedy_meshing_3d(data, size, differ_types = false, empty_value = 0):
	var BoxClass = global.SCRIPTS.BOX
	var iterator_range = range(size)
	var reverse_iterator_range = range(size-1,-1,-1)
	var direction_iterator_range = range(global.Faces.COUNT)
	
	var previous_neighbour_type = empty_value
	var x
	var y
	var z
	
	var boxes = []
	boxes.resize(size)
	var neighbour_data = []
	neighbour_data.resize(size)
	
	for x in iterator_range:
		boxes[x] = []
		boxes[x].resize(size)
		neighbour_data[x] = []
		neighbour_data[x].resize(size)
		for y in iterator_range:
			boxes[x][y] = []
			boxes[x][y].resize(size)
			neighbour_data[x][y] = []
			neighbour_data[x][y].resize(size)
			for z in iterator_range:
				boxes[x][y][z] = null
				neighbour_data[x][y][z] = 0
	
	var perform_culling = true
	
	for i in iterator_range:
		for j in iterator_range:
			# front to back
			x = i
			y = j
			previous_neighbour_type = empty_value
			for z in reverse_iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && ( previous_neighbour_type == empty_value || !perform_culling) ):
					neighbour_data[x][y][z] = -1
					boxes[x][y][z] = BoxClass.new(data[x][y][z] if differ_types else 1, Vector3(x,y,z), Vector3(0.5,0.5,0.5))
				previous_neighbour_type = data[x][y][z]
				
			# back to front
			x = i
			y = j
			previous_neighbour_type = empty_value
			for z in iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && ( previous_neighbour_type == empty_value || !perform_culling) ):
					neighbour_data[x][y][z] = -1
					boxes[x][y][z] = BoxClass.new(data[x][y][z] if differ_types else 1, Vector3(x,y,z), Vector3(0.5,0.5,0.5))
				previous_neighbour_type = data[x][y][z]
				
			# right to left
			z = i
			y = j
			previous_neighbour_type = empty_value
			for x in reverse_iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && ( previous_neighbour_type == empty_value || !perform_culling) ):
					neighbour_data[x][y][z] = -1
					boxes[x][y][z] = BoxClass.new(data[x][y][z] if differ_types else 1, Vector3(x,y,z), Vector3(0.5,0.5,0.5))
				previous_neighbour_type = data[x][y][z]
				
			# left to right
			z = i
			y = j
			previous_neighbour_type = empty_value
			for x in iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && ( previous_neighbour_type == empty_value || !perform_culling) ):
					neighbour_data[x][y][z] = -1
					boxes[x][y][z] = BoxClass.new(data[x][y][z] if differ_types else 1, Vector3(x,y,z), Vector3(0.5,0.5,0.5))
				previous_neighbour_type = data[x][y][z]
				
				
			# top to down
			x = i
			z = j
			previous_neighbour_type = empty_value
			for y in reverse_iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && ( previous_neighbour_type == empty_value || !perform_culling) ):
					neighbour_data[x][y][z] = -1
					boxes[x][y][z] = BoxClass.new(data[x][y][z] if differ_types else 1, Vector3(x,y,z), Vector3(0.5,0.5,0.5))
				previous_neighbour_type = data[x][y][z]
				
			# down to top
			x = i
			z = j
			previous_neighbour_type = empty_value
			for y in iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && ( previous_neighbour_type == empty_value || !perform_culling) ):
					neighbour_data[x][y][z] = -1
					boxes[x][y][z] = BoxClass.new(data[x][y][z] if differ_types else 1, Vector3(x,y,z), Vector3(0.5,0.5,0.5))
				previous_neighbour_type = data[x][y][z]

	var box
	var x_neighbour
	var y_neighbour
	var z_neighbour
	var keep_scanning_y
	var full_row
	var x_neighbour_range
	
	var full_grid
	var y_neighbour_range
	var keep_scanning_z

	var box_list = []
	# for each box in the box array
	for x in iterator_range:
		for y in iterator_range:
			for z in iterator_range:
				# if box is null, treat next box
				if( boxes[x][y][z] == null):
					continue
				# if box exists, removes it from box array and add it to list of box to return
				box = boxes[x][y][z]
				boxes[x][y][z] = null
				box_list.append(box)
				
				
				# set coordinate on the neighbour to the right
				x_neighbour = x+1
				# while end hasn't been reached and neighbour box exists and neighbour box type is the same as current box
				while( x_neighbour < size && boxes[x_neighbour][y][z] && boxes[x_neighbour][y][z].type == box.type ):
					# if all conditions are met, remove neighbour box
					boxes[x_neighbour][y][z] = null
					# increase current box size
					box.extents[0] += 0.5
					# set coordinate on the neighbour to the right
					x_neighbour += 1
				
				# set coordinate on the neighbour to the top
				y_neighbour = y+1
				keep_scanning_y = true
				# while end hasn't been reached and last loop ended up in a fusion of boxes
				while( y_neighbour < size && keep_scanning_y  ):
					# will be set to true if there's a fusion of boxes
					keep_scanning_y = false
					# will be set to false if the fusion isn't possible
					full_row = true
					
					# scanning each neighbour to the top of the box
					x_neighbour_range = range(x, x+box.extents[0]*2)
					for x_neighbour in x_neighbour_range:
						# if neighbour doesn't exist or is not of the same type as current box
						if( !boxes[x_neighbour][y_neighbour][z] || boxes[x_neighbour][y_neighbour][z].type != box.type ):
							# fusion isn't possible, set full_row to false
							full_row = false
							break
					# if fusion is possible
					if( full_row ):
						# remove all neighbours to the top
						for x_neighbour in x_neighbour_range:
							boxes[x_neighbour][y_neighbour][z] = null
						# increase current box size
						box.extents[1] += 0.5
						# set coordinate on the neighbour to the top
						y_neighbour += 1
						# keep scanning neighbours to the top
						keep_scanning_y = true
						
				# set coordinate on the neighbour to the front
				z_neighbour = z+1
				keep_scanning_z = true
				# while end hasn't been reached and last loop ended up in a fusion of boxes
				while( z_neighbour < size && keep_scanning_z ):
					# will be set to true if there's a fusion of boxes
					keep_scanning_z = false
					# will be set to false if the fusion isn't possible
					full_grid = true
					
					# scanning each neighbour on the neighbours to the front
					x_neighbour_range = range(x, x+box.extents[0]*2)
					y_neighbour_range = range(y, y+box.extents[1]*2)
					for x_neighbour in x_neighbour_range:
						for y_neighbour in y_neighbour_range:
							# if neighbour doesn't exist or is not of the same type as current box
							if( !boxes[x_neighbour][y_neighbour][z_neighbour] || boxes[x_neighbour][y_neighbour][z_neighbour].type != box.type ):
								# fusion isn't possible, set full_row to false
								full_grid = false
								break
					# if fusion is possible
					if( full_grid ):
						# remove all neighbours to the top
						for x_neighbour in x_neighbour_range:
							for y_neighbour in y_neighbour_range:
								boxes[x_neighbour][y_neighbour][z_neighbour] = null
						# increase current box size
						box.extents[2] += 0.5
						# set coordinate on the neighbour to the top
						z_neighbour += 1
						# keep scanning neighbours to the top
						keep_scanning_z = true
					  
				
	return box_list



static func greedy_meshing_2d(data, size, differ_types = false, empty_value = 0):
	var QuadClass = global.SCRIPTS.QUAD
	var iterator_range = range(size)
	var reverse_iterator_range = range(size-1,-1,-1)

	# Create a two dimensional array of quads, will contain all the raw quads of a given face before they are optimized
	var quads = []
	quads.resize(size)
	for x in iterator_range:
		quads[x] = []
		quads[x].resize(size)

	# A list of quads, will contain the final quads that will be displayed
	var to_display_quads = []
	
	# tmp variables
	var quad_type
	var neighbour_voxel_type
	var new_quads_to_display

	# The following code is duplicated for every face
	# Currently it doesn't consume lot of ram at once, but things could be done in a smarter way
	
	# Front
	# For each layer of the front face
	for z in iterator_range:
		# For each slot of the front face
		for x in iterator_range:
			for y in iterator_range:
				# If the slot isn't empty and the neighbour slot in front of it isn't full
				neighbour_voxel_type = data[x][y][z+1] if z+1 < size else empty_value
				if( data[x][y][z] != empty_value && neighbour_voxel_type == empty_value ):
					quad_type = data[x][y][z] if differ_types else 1
					# Register the quad
					quads[x][y] = QuadClass.new(quad_type, Vector3(x,y,z), global.Faces.FRONT, 1, 1)
				else:
					quads[x][y] = null
					
		# Optimize the quads with greedy meshing
		new_quads_to_display = greedy_mesh_surface(quads, size)
		add_to_array(to_display_quads, new_quads_to_display)

	# Back
		for x in iterator_range:
			for y in iterator_range:
				neighbour_voxel_type = data[x][y][z-1] if z-1 > 0 else empty_value
				if( data[x][y][z] != empty_value && neighbour_voxel_type == empty_value ):
					quad_type = data[x][y][z] if differ_types else 1
					quads[x][y] = QuadClass.new(quad_type, Vector3(x,y,z), global.Faces.BACK, 1, 1)
				else:
					quads[x][y] = null

		new_quads_to_display = greedy_mesh_surface(quads, size)
		add_to_array(to_display_quads, new_quads_to_display)

	# Right
	for x in iterator_range:
		for z in iterator_range:
			for y in iterator_range:
				neighbour_voxel_type = data[x+1][y][z] if x+1 < size else empty_value
				if( data[x][y][z] != empty_value && neighbour_voxel_type == empty_value ):
					quad_type = data[x][y][z] if differ_types else 1
					quads[z][y] = QuadClass.new(quad_type, Vector3(x,y,z), global.Faces.RIGHT, 1, 1)
				else:
					quads[z][y] = null

		new_quads_to_display = greedy_mesh_surface(quads, size)
		add_to_array(to_display_quads, new_quads_to_display)

	# Left
		for z in iterator_range:
			for y in iterator_range:
				neighbour_voxel_type = data[x-1][y][z] if x-1 > 0 else empty_value
				if( data[x][y][z] != empty_value && neighbour_voxel_type == empty_value ):
					quad_type = data[x][y][z] if differ_types else 1
					quads[z][y] = QuadClass.new(quad_type, Vector3(x,y,z), global.Faces.LEFT, 1, 1)
				else:
					quads[z][y] = null

		new_quads_to_display = greedy_mesh_surface(quads, size)
		add_to_array(to_display_quads, new_quads_to_display)

	# Top
	for y in iterator_range:
		for x in iterator_range:
			for z in iterator_range:
				neighbour_voxel_type = data[x][y+1][z] if y+1 < size else empty_value
				if( data[x][y][z] != empty_value && neighbour_voxel_type == empty_value ):
					quad_type = data[x][y][z] if differ_types else 1
					quads[x][z] = QuadClass.new(quad_type, Vector3(x,y,z), global.Faces.TOP, 1, 1)
				else:
					quads[x][z] = null

		new_quads_to_display = greedy_mesh_surface(quads, size)
		add_to_array(to_display_quads, new_quads_to_display)
			
	# Bottom
		for x in iterator_range:
			for z in iterator_range:
				neighbour_voxel_type = data[x][y-1][z] if y-1 > 0 else empty_value
				if( data[x][y][z] != empty_value && neighbour_voxel_type == empty_value ):
					quad_type = data[x][y][z] if differ_types else 1
					quads[x][z] = QuadClass.new(quad_type, Vector3(x,y,z), global.Faces.BOTTOM, 1, 1)
				else:
					quads[x][z] = null

		new_quads_to_display = greedy_mesh_surface(quads, size)
		add_to_array(to_display_quads, new_quads_to_display)
	
	return to_display_quads


static func add_to_array(array, array_to_add):
	var iterator_range = range(array_to_add.size())
	for i in iterator_range:
		array.append(array_to_add[i])
	return array

static func get_neighbour_voxel_type  ( data, size, current_voxel, direction, empty_value = 0):
	var neighbour_voxel = current_voxel + global.FaceDirections[direction]
	if( neighbour_voxel[neighbour_voxel.min_axis()] < 0 || neighbour_voxel[neighbour_voxel.max_axis()] >= size ):
		return empty_value
	return data[neighbour_voxel.x][neighbour_voxel.y][neighbour_voxel.z]

static func greedy_mesh_surface( quads, size ):
	# Quads is a two dimensional array of size size x size

	var quad
	var return_quads = []
	var x_neighbour
	var x_neighbour_range
	var y_neighbour
	var keep_scanning_rows
	var full_row
	var iterator_range = range(size)

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
			while( x_neighbour < size && quads[x_neighbour][y] && quads[x_neighbour][y].type == quad.type ):
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
			while( y_neighbour < size && keep_scanning_rows  ):
				keep_scanning_rows = false
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
					for x_neighbour in x_neighbour_range:
						# Remove the quad in the slot
						quads[x_neighbour][y_neighbour] = null
					# Increase the height of the current quad
					quad.h +=1
					# Set position to the next neighbour row to the bottom
					y_neighbour += 1
					# We expended the current quad, we can continue scanning neighbour rows bellow
					keep_scanning_rows = true

	return return_quads