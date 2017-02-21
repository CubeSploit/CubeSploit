var OctreeNode = get_script()
var OctreeChunkScene = global.SCENES.OCTREE_CHUNK

var size
var body
var parent

var pos
var depth
var octree_pos

var chunk

var is_leaf = false
var is_root = false

var children

func _init(size, body, pos = Vector3(-0.5,-0.5,-0.5), parent = null):
	self.pos = pos
	
	# if parent is null, then it's a root
	if( !parent ):
		is_root = true
		depth = 0
		octree_pos = pos
	else:
		depth = parent.depth + 1
#		this
#		0
#		0								1
#		0				1				0				1
#		0		1		0		1		0		1		0		1
#		0	1	0	1	0	1	0	1	0	1	0	1	0	1	0	1
#		
#		becomes
#		0
#		-1								0
#		-2				-1				0				1
#		-4		-3		-2		-1		0		1		2		3
#		-8	-7	-6	-5	-4	-3	-2	-1	0	1	2	3	4	5	6	7
		octree_pos = parent.octree_pos*2 + pos
		
	if( size == body.chunk_size ):
		is_leaf = true
	
	self.size = size
	self.body = body
	self.parent = parent
	
	chunk = OctreeChunkScene.instance()
	chunk.init( self, self.body )
	
	var parent_pos = Vector3(0,0,0)
	if( parent ):
		parent_pos = parent.chunk.get_translation()
	chunk.set_translation(  parent_pos +  pos * size)
	body.add_child(chunk)
	
	if( !self.is_leaf ):
		self.children = []
		self.children.resize(2)
		for x in range(2):
			self.children[x] = []
			self.children[x].resize(2)
			for y in range(2):
				self.children[x][y] = []
				self.children[x][y].resize(2)
				for z in range(2):
					self.children[x][y][z] = OctreeNode.new(size/2, body, Vector3(x,y,z), self)
	chunk.set_scale( Vector3(1,1,1) * (size/body.chunk_size) )


func init_leaves(chunk_initializer_name):
	if( !self.is_leaf ):
		for x in range(2):
			for y in range(2):
				for z in range(2):
					children[x][y][z].init_leaves(chunk_initializer_name)
	else:
		chunk.initialize(chunk_initializer_name)
func init_nodes(chunk_initializer_name):
	if( !self.is_leaf ):
		for x in range(2):
			for y in range(2):
				for z in range(2):
					children[x][y][z].init_nodes(chunk_initializer_name)
		chunk.initialize(chunk_initializer_name)

func generate_mesh():
	if( !is_leaf ):
		for x in range(2):
			for y in range(2):
				for z in range(2):
					children[x][y][z].generate_mesh( )
	chunk.generate_mesh( body.voxel_material )
func generate_shapes():
	if( !is_leaf ):
		for x in range(2):
			for y in range(2):
				for z in range(2):
					children[x][y][z].generate_shapes( )
	else:
		chunk.generate_shapes( body.get_rid() )
