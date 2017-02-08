
static func culling_3d(data, size, empty_value = 0):
	var BoxClass = global.SCRIPTS.BOX
	var iterator_range = range(size)
	var reverse_iterator_range = range(size-1,-1,-1)
	var direction_iterator_range = range(global.Faces.COUNT)
	
	var boxes = []
	var previous_neighbour_type = empty_value
	var x
	var y
	var z
	
	var neighbour_data = []
	neighbour_data.resize(size)
	
	for x in iterator_range:
		neighbour_data[x] = []
		neighbour_data[x].resize(size)
		for y in iterator_range:
			neighbour_data[x][y] = []
			neighbour_data[x][y].resize(size)
			for z in iterator_range:
				neighbour_data[x][y][z] = 0
			
	for i in iterator_range:
		for j in iterator_range:
			# front to back
			x = i
			y = j
			previous_neighbour_type = empty_value
			for z in reverse_iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					neighbour_data[x][y][z] = -1
					boxes.append( BoxClass.new(data[x][y][z], Vector3(x,y,z), Vector3(0.5,0.5,0.5)))
				previous_neighbour_type = data[x][y][z]
				
			# back to front
			x = i
			y = j
			previous_neighbour_type = empty_value
			for z in iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					neighbour_data[x][y][z] = -1
					boxes.append( BoxClass.new(data[x][y][z], Vector3(x,y,z), Vector3(0.5,0.5,0.5)))
				previous_neighbour_type = data[x][y][z]
				
			# right to left
			z = i
			y = j
			previous_neighbour_type = empty_value
			for x in reverse_iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					neighbour_data[x][y][z] = -1
					boxes.append( BoxClass.new(data[x][y][z], Vector3(x,y,z), Vector3(0.5,0.5,0.5)))
				previous_neighbour_type = data[x][y][z]
				
			# left to right
			z = i
			y = j
			previous_neighbour_type = empty_value
			for x in iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					neighbour_data[x][y][z] = -1
					boxes.append( BoxClass.new(data[x][y][z], Vector3(x,y,z), Vector3(0.5,0.5,0.5)))
				previous_neighbour_type = data[x][y][z]
				
				
			# top to down
			x = i
			z = j
			previous_neighbour_type = empty_value
			for y in reverse_iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					neighbour_data[x][y][z] = -1
					boxes.append( BoxClass.new(data[x][y][z], Vector3(x,y,z), Vector3(0.5,0.5,0.5)))
				previous_neighbour_type = data[x][y][z]
				
			# down to top
			x = i
			z = j
			previous_neighbour_type = empty_value
			for y in iterator_range:
				if( neighbour_data[x][y][z] == 0 && data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					neighbour_data[x][y][z] = -1
					boxes.append( BoxClass.new(data[x][y][z], Vector3(x,y,z), Vector3(0.5,0.5,0.5)))
				previous_neighbour_type = data[x][y][z]
				
	return boxes
	

static func culling_2d(data, size, empty_value = 0):
	var QuadClass = global.SCRIPTS.QUAD
	var iterator_range = range(size)
	var reverse_iterator_range = range(size-1,-1,-1)
	var direction_iterator_range = range(global.Faces.COUNT)

	var quads = []
	var previous_neighbour_type = empty_value
	var x
	var y
	var z
	
	for i in iterator_range:
		for j in iterator_range:
			# front to back
			x = i
			y = j
			previous_neighbour_type = empty_value
			for z in reverse_iterator_range:
				if( data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					quads.append( QuadClass.new(data[x][y][z], Vector3(x,y,z), global.Faces.FRONT, 1, 1) )
				previous_neighbour_type = data[x][y][z]
				
			# back to front
			x = i
			y = j
			previous_neighbour_type = empty_value
			for z in iterator_range:
				if( data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					quads.append( QuadClass.new(data[x][y][z], Vector3(x,y,z), global.Faces.BACK, 1, 1) )
				previous_neighbour_type = data[x][y][z]
				
			# right to left
			z = i
			y = j
			previous_neighbour_type = empty_value
			for x in reverse_iterator_range:
				if( data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					quads.append( QuadClass.new(data[x][y][z], Vector3(x,y,z), global.Faces.RIGHT, 1, 1) )
				previous_neighbour_type = data[x][y][z]
				
			# left to right
			z = i
			y = j
			previous_neighbour_type = empty_value
			for x in iterator_range:
				if( data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					quads.append( QuadClass.new(data[x][y][z], Vector3(x,y,z), global.Faces.LEFT, 1, 1) )
				previous_neighbour_type = data[x][y][z]
				
				
			# top to down
			x = i
			z = j
			previous_neighbour_type = empty_value
			for y in reverse_iterator_range:
				if( data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					quads.append( QuadClass.new(data[x][y][z], Vector3(x,y,z), global.Faces.TOP, 1, 1) )
				previous_neighbour_type = data[x][y][z]
				
			# down to top
			x = i
			z = j
			previous_neighbour_type = empty_value
			for y in iterator_range:
				if( data[x][y][z] != empty_value && previous_neighbour_type == empty_value):
					quads.append( QuadClass.new(data[x][y][z], Vector3(x,y,z), global.Faces.BOTTOM, 1, 1) )
				previous_neighbour_type = data[x][y][z]
			
	return quads

# this implementation works and is shorter in the script, but is maybe 25% to 40% slower because of the use of get_neighbour_voxel_type function
#static func culling_2d2(data, size, empty_value = 0):
#	var QuadClass = global.SCRIPTS.QUAD
#	var iterator_range = range(size)
#	var direction_iterator_range = range(global.Faces.COUNT)
#	
#	var quads = []
#	
#	var neighbour_voxel_type
#	
#	for x in iterator_range:
#		for y in iterator_range:
#			for z in iterator_range:
#				if( data[x][y][z] != empty_value ):
#					for d in direction_iterator_range:
#						neighbour_voxel_type = get_neighbour_voxel_type( data, size, Vector3(x,y,z), d, empty_value) 
#						if( neighbour_voxel_type == empty_value ):
#							quads.append( QuadClass.new(data[x][y][z], Vector3(x,y,z), d, 1, 1) )
#	
#	return quads

#static func get_neighbour_voxel_type  ( data, size, current_voxel, direction, empty_value = 0):
#	var neighbour_voxel = current_voxel + global.FaceDirections[direction]
#	if( neighbour_voxel[neighbour_voxel.min_axis()] < 0 || neighbour_voxel[neighbour_voxel.max_axis()] >= size ):
#		return empty_value
#	return data[neighbour_voxel.x][neighbour_voxel.y][neighbour_voxel.z]