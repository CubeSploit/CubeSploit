var OctreeNode = get_script()
var OctreeChunk = global.SCRIPTS.OCTREE_CHUNK

var size
var body
var parent

var chunk

var is_leaf = false
var is_root = false

var children

func _init(size, body, octree_pos = Vector3(0,0,0), parent = null):
	if( !parent ):
		is_root = true
	if( size == body.chunk_size ):
		is_leaf = true
	
	self.size = size
	self.body = body
	self.parent = parent
	
	chunk = OctreeChunk.new( self.body )
	self.body.add_child(chunk)
	var parent_pos = Vector3(0,0,0)
	if( parent ):
		parent_pos = parent.chunk.get_translation()
	chunk.set_translation(  parent_pos +  octree_pos*size + (Vector3( 5+16,0,0)))
	chunk.octree_node = self
	
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
		chunk.init_from_bellow()
	else:
		chunk.generate_random()
		
	chunk.generate_mesh( body.voxel_material )
	chunk.set_scale( Vector3(1,1,1) * (size/body.chunk_size) )
	