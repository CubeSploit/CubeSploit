extends MeshInstance

const Quad = preload("res://world/body/quad.gd")

var pos = Vector3(0,0,0)
var size = 32
var raw_data = [] # sixe * sixe 2D array
var body = null # ref of the parent node
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
	# create and initialize the surfacetool and other handy variables
	var st = SurfaceTool.new()
	st.begin(VisualServer.PRIMITIVE_TRIANGLES)
	st.set_material( voxel_material )
	var idx = 0

	# create a two dimensional array of quads, will contain all the raw quads of a given face before they are optimized
	var quads = []
	quads.resize(size)
	for x in iterator_range:
		quads[x] = []
		quads[x].resize(size)

	# a list of quads, will contain the final quads that will be displayed
	var to_display_quads

	# the following code is duplicated for every face
	# currently it doesn't consume lot of ram at once, but things could be done in a smarter way
	
	# front
	# for each layer of the front face
	for z in iterator_range:
		# for each slot of the front face
		for x in iterator_range:
			for y in iterator_range:
				# if the slot isn't empty and the neighbour slot in front of it isn't full
				if( raw_data[x][y][z] != global.VoxelTypes.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.FRONT) == global.VoxelTypes.EMPTY ):
					# register the quad
					quads[x][y] = Quad.new(raw_data[x][y][z], Vector3(x,y,z),global.Faces.FRONT, x, y, 1, 1)
				else:
					quads[x][y] = null
		# optimize the quads with greedy meshing
		to_display_quads = greedy_mesh(quads)
		# for each quads in the list of quads to display
		for quad in to_display_quads:
			# add quad to surface tool
			idx = quad.add_to_surface(st, idx)

	# back
	for z in iterator_range:
		for x in iterator_range:
			for y in iterator_range:
				if( raw_data[x][y][z] != global.VoxelTypes.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.BACK) == global.VoxelTypes.EMPTY ):
					quads[x][y] = Quad.new(raw_data[x][y][z], Vector3(x,y,z), global.Faces.BACK, x, y, 1, 1)
				else:
					quads[x][y] = null

		to_display_quads = greedy_mesh(quads)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx)

	# right
	for x in iterator_range:
		for z in iterator_range:
			for y in iterator_range:
				if( raw_data[x][y][z] != global.VoxelTypes.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.RIGHT) == global.VoxelTypes.EMPTY ):
					quads[z][y] = Quad.new(raw_data[x][y][z], Vector3(x,y,z), global.Faces.RIGHT, z, y, 1, 1)
				else:
					quads[z][y] = null

		to_display_quads = greedy_mesh(quads)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx)

	# left
	for x in iterator_range:
		for z in iterator_range:
			for y in iterator_range:
				if( raw_data[x][y][z] != global.VoxelTypes.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.LEFT) == global.VoxelTypes.EMPTY ):
					quads[z][y] = Quad.new(raw_data[x][y][z], Vector3(x,y,z), global.Faces.LEFT, z, y, 1, 1)
				else:
					quads[z][y] = null

		to_display_quads = greedy_mesh(quads)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx)

	# top
	for y in iterator_range:
		for x in iterator_range:
			for z in iterator_range:
				if( raw_data[x][y][z] != global.VoxelTypes.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.TOP) == global.VoxelTypes.EMPTY ):
					quads[x][z] = Quad.new(raw_data[x][y][z], Vector3(x,y,z), global.Faces.TOP, x, z, 1, 1)
				else:
					quads[x][z] = null

		to_display_quads = greedy_mesh(quads)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx)
			
	# bottom
	for y in iterator_range:
		for x in iterator_range:
			for z in iterator_range:
				if( raw_data[x][y][z] != global.VoxelTypes.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.BOTTOM) == global.VoxelTypes.EMPTY ):
					quads[x][z] = Quad.new(raw_data[x][y][z], Vector3(x,y,z), global.Faces.BOTTOM, x, z, 1, 1)
				else:
					quads[x][z] = null

		to_display_quads = greedy_mesh(quads)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx)

	# commit the mesh
	set_mesh(st.commit())


func greedy_mesh( quads ):
	# quads is a two dimensional array of size chunk_size x chunk_size

	var quad
	var return_quads = []
	var x_neighbour
	var x_neighbour_range
	var y_neighbour
	var keep_scanning_rows
	var full_row

	# for each slot of the surface
	for x in iterator_range:
		for y in iterator_range:
			# if the slot is empty, continue to next loop
			if( quads[x][y] == null):
				continue
			# if the slot has a quad

			# remove it from the input quads and put it in the output quads
			quad = quads[x][y]
			quads[x][y] = null
			return_quads.append(quad)

			# while horizontal end is not reached and there is a neighbour slot to the right with a quad of the same type
			# set position to the neighbour slot to the right
			x_neighbour = x+1
			while( x_neighbour < size && quads[x_neighbour][y] && quads[x_neighbour][y].type == quad.type ):
				# remove that neighbour quad and increase the current quad's width
				quads[x_neighbour][y] = null
				quad.w += 1
				# next neighbour slot to the right
				x_neighbour +=1

			# at this point, the slot to the right is empty or has a quad of different type, we can't expend the current quad further to the right
			
			# set position to the neighbour row of slots to the bottom
			y_neighbour = y+1
			# this boolean will determine if we continue scanning next row, typically if we successfuly extended the current quad to the bottom we continue scanning
			keep_scanning_rows = true
			# while vertical end is not reached and we're allowed to keep scanning neighbours of the row bellow, meaning the current quad was extended to the bottom during previous loop
			while( y_neighbour < size && keep_scanning_rows  ):
				# this boolean will determine if all slot of the row bellow our current quad contains quads of the same type
				full_row = true
				# for each slot of the row bellow the current quad
				x_neighbour_range = range(x, x+quad.w)
				for x_neighbour in x_neighbour_range:
					# if one slot of the row hasn't a quad or has a quad of a different type
					if( !quads[x_neighbour][y_neighbour] || quads[x_neighbour][y_neighbour].type != quad.type ):
						# stop the scanning and say the row is not full
						full_row = false
						break
				# if the row is full of quads of the same type, we can extend the current quad
				if( full_row ):
					# for each slot of the row bellow
					x_neighbour_range = range(x, x+quad.w)
					for x_neighbour in x_neighbour_range:
						# remove the quad in the slot
						quads[x_neighbour][y_neighbour] = null
					# increase the height of the current quad
					quad.h +=1
					# set position to the next neighbour row to the bottom
					y_neighbour += 1
					# we expended the current quad, we can continue scanning neighbour rows bellow
					keep_scanning_rows = true
				# if the row is not full
				else:
					# do not allow to scan the next line, current quad can't be expended anymore
					keep_scanning_rows = false

	return return_quads





