extends MeshInstance

var size = 32
var raw_data = [] # size * size * size 3D array
var body = null # ref of the parent node

func _init(body, size):
	self.body = body
	self.size = size

func generate_random( ):
	raw_data = []
	raw_data.resize(size)
	for x in range(size):
		raw_data[x] = []
		raw_data[x].resize(size)
		for y in range(size):
			raw_data[x][y] = []
			raw_data[x][y].resize(size)
			for z in range(size):
				if randf() > 0:
					raw_data[x][y][z] = (randi()%(global.Voxel_Types.COUNT-1))+1
				else:
					raw_data[x][y][z] = 0
#				raw_data[x][y][z] = randi()%global.Voxel_Types.COUNT
#				raw_data[x][y][z] = 1


func get_neighbour_voxel(current_voxel, direction):
	var neighbour_voxel = Vector3(current_voxel)

	if( direction == global.Faces.FRONT ):
		neighbour_voxel.z +=1
	elif( direction == global.Faces.BACK ):
		neighbour_voxel.z -=1

	elif( direction == global.Faces.RIGHT ):
		neighbour_voxel.x +=1
	elif( direction == global.Faces.LEFT ):
		neighbour_voxel.x -=1

	elif( direction == global.Faces.TOP):
		neighbour_voxel.y +=1
	elif( direction == global.Faces.BOTTOM ):
		neighbour_voxel.y -=1

	return neighbour_voxel

func get_neighbour_voxel_type ( current_voxel, direction ):
	var neighbour_voxel = get_neighbour_voxel( current_voxel, direction )
	if( neighbour_voxel[neighbour_voxel.min_axis()] < 0 || neighbour_voxel[neighbour_voxel.max_axis()] >= size ):
		return global.Voxel_Types.EMPTY
		
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
	for x in range(size):
		quads[x] = []
		quads[x].resize(size)

	# a list of quads, will contain the final quads that will be displayed
	var to_display_quads

	# the following code is duplicated for every face
	# currently it doesn't consume lot of ram at once, but things could be done in a smarter way
	
	# front
	# for each layer of the front face
	for z in range(size):
		# for each slot of the front face
		for x in range(size):
			for y in range(size):
				# if the slot isn't empty and the neighbour slot in front of it isn't full
				if( raw_data[x][y][z] != global.Voxel_Types.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.FRONT) == global.Voxel_Types.EMPTY ):
					# register the quad
					quads[x][y] = global.classes.quad.new(raw_data[x][y][z], Vector3(x,y,z),global.Faces.FRONT, x, y, 1, 1)
		# optimize the quads with greedy meshing
		to_display_quads = greedy_mesh(quads)
		# for each quads in the list of quads to display
		for quad in to_display_quads:
			# add quad to surface tool
			idx = quad.add_to_surface(st, idx, -get_translation()+Vector3(size,size,size)/2)

	# back
	for z in range(size):
		for x in range(size):
			for y in range(size):
				if( raw_data[x][y][z] != global.Voxel_Types.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.BACK) == global.Voxel_Types.EMPTY ):
					quads[x][y] = global.classes.quad.new(raw_data[x][y][z], Vector3(x,y,z), global.Faces.BACK, x, y, 1, 1)

		to_display_quads = greedy_mesh(quads)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx, -get_translation()+Vector3(size,size,size)/2)

	# right
	for x in range(size):
		for z in range(size):
			for y in range(size):
				if( raw_data[x][y][z] != global.Voxel_Types.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.RIGHT) == global.Voxel_Types.EMPTY ):
					quads[z][y] = global.classes.quad.new(raw_data[x][y][z], Vector3(x,y,z), global.Faces.RIGHT, z, y, 1, 1)

		to_display_quads = greedy_mesh(quads)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx, -get_translation()+Vector3(size,size,size)/2)

	# left
	for x in range(size):
		for z in range(size):
			for y in range(size):
				if( raw_data[x][y][z] != global.Voxel_Types.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.LEFT) == global.Voxel_Types.EMPTY ):
					quads[z][y] = global.classes.quad.new(raw_data[x][y][z], Vector3(x,y,z), global.Faces.LEFT, z, y, 1, 1)

		to_display_quads = greedy_mesh(quads)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx, -get_translation()+Vector3(size,size,size)/2)

	# top
	for y in range(size):
		for x in range(size):
			for z in range(size):
				if( raw_data[x][y][z] != global.Voxel_Types.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.TOP) == global.Voxel_Types.EMPTY ):
					quads[x][z] = global.classes.quad.new(raw_data[x][y][z], Vector3(x,y,z), global.Faces.TOP, x, z, 1, 1)

		to_display_quads = greedy_mesh(quads)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx, -get_translation()+Vector3(size,size,size)/2)
			
	# top
	for y in range(size):
		for x in range(size):
			for z in range(size):
				if( raw_data[x][y][z] != global.Voxel_Types.EMPTY && get_neighbour_voxel_type(Vector3(x,y,z), global.Faces.BOTTOM) == global.Voxel_Types.EMPTY ):
					quads[x][z] = global.classes.quad.new(raw_data[x][y][z], Vector3(x,y,z), global.Faces.BOTTOM, x, z, 1, 1)

		to_display_quads = greedy_mesh(quads)
		for quad in to_display_quads:
			idx = quad.add_to_surface(st, idx, -get_translation()+Vector3(size,size,size)/2)

	# commit the mesh
	st.generate_normals()
	set_mesh(st.commit())


func greedy_mesh( quads ):
	# quads is a two dimensional array of size chunk_size x chunk_size

	var quad
	var return_quads = []
	var x_offset
	var y_offset
	var keep_scanning_rows
	var full_row

	# for each slot of the surface
	for x in range(size):
		for y in range(size):
			# if the slot is empty, continue to next loop
			if( quads[x][y] == null):
				continue
			# if the slot has a quad

			# remove it from the input quads and put it in the output quads
			quad = quads[x][y]
			quads[x][y] = null
			return_quads.append(quad)

			# set offset to the neighbour slot to the right
			x_offset = 1
			# while horizontal end is not reached and there is a neighbour slot to the right with a quad of the same type
			while( x+x_offset < size && quads[x+x_offset][y] && quads[x+x_offset][y].type == quad.type ):
				break
				# remove that neighbour quad and increase the current quad's width
				quads[x+x_offset][y] = null
				quad.w += 1
				# next neighbour slot to the right
				x_offset +=1

			# at this point, the slot to the right is empty or has a quad of different type, we can't expend the current quad further to the right
			
			# set offset to the neighbour row of slots to the bottom
			y_offset = 1
			# this boolean will determine if we continue scanning next row, typically if we successfuly extended the current quad to the bottom we continue scanning
			keep_scanning_rows = true
			# while vertical end is not reached and we're allowed to keep scanning neighbours of the row bellow, meaning the current quad was extended to the bottom during previous loop
			while( y+y_offset < size && keep_scanning_rows  ):
				break
				# this boolean will determine if all slot of the row bellow our current quad contains quads of the same type
				full_row = true
				# for each slot of the row bellow the current quad
				for x_offset in range(quad.w):
					# if one slot of the row hasn't a quad or has a quad of a different type
					if( !quads[x+x_offset][y+y_offset] || quads[x+x_offset][y+y_offset].type != quad.type ):
						# stop the scanning and say the row is not full
						full_row = false
						break
				# if the row is full of quads of the same type, we can extend the current quad
				if( full_row ):
					# for each slot of the row bellow
					for x_offset in range(quad.w):
						# remove the quad in the slot
						quads[x+x_offset][y+y_offset] = null
					# increase the height of the current quad
					quad.h +=1
					# set offset to the next neighbour row to the bottom
					y_offset += 1
					# we expended the current quad, we can continue scanning neighbour rows bellow
					keep_scanning_rows = true
				# if the row is not full
				else:
					# do not allow to scan the next line, current quad can't be expended anymore
					keep_scanning_rows = false

	return return_quads





