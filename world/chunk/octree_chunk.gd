extends MeshInstance

var size = 0
var scale = 1
var raw_data # size * sixe * sixe 3D array
var initialized = false
var body = null # Ref of the parent node
var iterator_range # Optimization, would have to be removed when real iterators come

var octree_node

var in_player_range = false
	
func init(octree_node, body):
	self.body = body
	self.size = body.chunk_size
	self.scale = octree_node.size / size
	iterator_range = range(size) # Optimization, would have to be removed when real iterators come
	self.octree_node = octree_node
#	if( self.octree_node.parent):
#		set_hidden(true)

	# this allows LOD switch of chunks but the transition isn't perfect and needs to be reworked
	if( !self.octree_node.is_leaf ):
		set_draw_range_begin( 100*(scale/2) )
	set_draw_range_end( 100*scale )
	if( !self.octree_node.parent ):
		set_draw_range_end( 100*scale * 1000 )


func generate_with_body_initializer( body_initializer_name ):
	global.BODY_INITIALIZERS[body_initializer_name].initialize_chunk( body, self)
#	thread_pool.add_task( global.BODY_INITIALIZERS[body_initializer_name], "initialize_chunk", [body, self])

func generate_empty():
	global.CHUNK_INITIALIZERS.EMPTY_INITIALIZER.initialize_chunk( self )
	
func generate_random( ):
#	global.CHUNK_INITIALIZERS.RANDOM_INITIALIZER.initialize_chunk( self )
	global.CHUNK_INITIALIZERS.RANDOM_PLAIN_INITIALIZER.initialize_chunk( self )

func init_from_bellow( ):
	global.CHUNK_INITIALIZERS.OCTREE_UPWARD_NAIVE_INITIALIZER.initialize_chunk( self )


func get_neighbour_voxel_type ( current_voxel, direction ):
	var neighbour_voxel = current_voxel + global.FaceDirections[direction]
	if( neighbour_voxel[neighbour_voxel.min_axis()] < 0 || neighbour_voxel[neighbour_voxel.max_axis()] >= size ):
		return global.VoxelTypes.EMPTY
	return raw_data[neighbour_voxel.x][neighbour_voxel.y][neighbour_voxel.z]




func generate_mesh( voxel_material ):
	if( !initialized ):
		return
		
	var shapes = global.MESHING_ALGORITHMS.GREEDY_MESHING.greedy_meshing_2d( raw_data, size, true, global.VoxelTypes.EMPTY)

	var shapes_iterator_range = range(shapes.size())
	var st = SurfaceTool.new()
	st.begin(VisualServer.PRIMITIVE_TRIANGLES)
	st.set_material( voxel_material )
	var idx = 0
	for i in shapes_iterator_range:
		idx = shapes[i].add_to_surface(st, idx, scale)
	set_mesh(st.commit())
	
func generate_shapes( body_rid ):
	if( !initialized ):
		return
		
	var shapes = global.MESHING_ALGORITHMS.GREEDY_MESHING.greedy_meshing_3d( raw_data, size, false, global.VoxelTypes.EMPTY)
	
	var shapes_iterator_range = range(shapes.size())
	for i in shapes_iterator_range:
		shapes[i].add_to_body(body_rid, get_translation(), scale)

#func _on_Area_body_enter_shape( body_id, body, body_shape, area_shape ):
#	print("hey ")
#	if body extends global.SCRIPTS.PLAYER:
#		in_player_range = true
#		set_hidden(false)
#		if( octree_node.parent ):
#			octree_node.parent.child_in_range()
#
#func _on_Area_body_exit_shape( body_id, body, body_shape, area_shape ):
#	if body extends global.SCRIPTS.PLAYER:
#		in_player_range = false
#		if( octree_node.parent ):
#			octree_node.parent.child_out_of_range()
