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
	global.CHUNK_INITIALIZERS.RANDOM_INITIALIZER.initialize( self )
	
func init_from_bellow( ):
	global.CHUNK_INITIALIZERS.OCTREE_UPWARD_NAIVE_INITIALIZE.initialize( self )
	
							

func get_neighbour_voxel_type ( current_voxel, direction ):
	var neighbour_voxel = current_voxel + global.FaceDirections[direction]
	if( neighbour_voxel[neighbour_voxel.min_axis()] < 0 || neighbour_voxel[neighbour_voxel.max_axis()] >= size ):
		return global.VoxelTypes.EMPTY
	return raw_data[neighbour_voxel.x][neighbour_voxel.y][neighbour_voxel.z]

func generate_mesh( voxel_material ):
	set_mesh( global.CHUNK_OPTIMIZERS.GREEDY_MESHING_OPTIMIZER.optimize( self, voxel_material ) )





func _on_Area_body_enter_shape( body_id, body, body_shape, area_shape ):
	in_player_range = true
	set_hidden(false)
	if( octree_node.parent ):
		octree_node.parent.child_in_range()

func _on_Area_body_exit_shape( body_id, body, body_shape, area_shape ):
	in_player_range = false
	if( octree_node.parent ):
		octree_node.parent.child_out_of_range()
