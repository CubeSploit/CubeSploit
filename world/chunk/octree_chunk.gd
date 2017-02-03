extends MeshInstance

var size = 32
var raw_data = [] # size * sixe * sixe 3D array
var body = null # Ref of the parent node
var iterator_range # Optimization, would have to be removed when real iterators come

var octree_node

var in_player_range = false
	
func init(octree_node, body):
	self.body = body
	self.size = body.chunk_size
	iterator_range = range(size) # Optimization, would have to be removed when real iterators come
	self.octree_node = octree_node
	if( self.octree_node.parent ):
		set_hidden(true)

func generate_random( ):
	global.CHUNK_INITIALIZERS.RANDOM_INITIALIZER.initialize_chunk( self )
#	global.CHUNK_INITIALIZERS.RANDOM_PLAIN_INITIALIZER.initialize_chunk( self )

func init_from_bellow( ):
	global.CHUNK_INITIALIZERS.OCTREE_UPWARD_NAIVE_INITIALIZE.initialize_chunk( self )



func get_neighbour_voxel_type ( current_voxel, direction ):
	var neighbour_voxel = current_voxel + global.FaceDirections[direction]
	if( neighbour_voxel[neighbour_voxel.min_axis()] < 0 || neighbour_voxel[neighbour_voxel.max_axis()] >= size ):
		return global.VoxelTypes.EMPTY
	return raw_data[neighbour_voxel.x][neighbour_voxel.y][neighbour_voxel.z]

func generate_mesh( voxel_material, scale ):
	set_mesh( global.CHUNK_OPTIMIZERS.GREEDY_MESHING_OPTIMIZER.optimize_mesh( self, voxel_material, scale ) )

func generate_shapes( body_rid, scale ):
#	global.CHUNK_OPTIMIZERS.GREEDY_MESHING_OPTIMIZER.optimize_shapes( self, body_rid, scale )
	global.CHUNK_SHAPERS.CULLING_SHAPER.optimize_shapes( self, body_rid, scale )

func _on_Area_body_enter_shape( body_id, body, body_shape, area_shape ):
	if body extends global.SCRIPTS.PLAYER:
		in_player_range = true
		set_hidden(false)
		if( octree_node.parent ):
			octree_node.parent.call_deferred("child_in_range")

func _on_Area_body_exit_shape( body_id, body, body_shape, area_shape ):
	if body extends global.SCRIPTS.PLAYER:
		in_player_range = false
		if( octree_node.parent ):
			octree_node.parent.call_deferred("child_out_of_range")
