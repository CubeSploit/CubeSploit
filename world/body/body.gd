extends Spatial

var OctreeNode = global.SCRIPTS.OCTREE_NODE

export(Material) var voxel_material
export(Material) var voxel_material_text

var chunk_size = 2
var chunks = [] # 3D array containing the chunks of the body


var octree_root
func generate_random_octree( body_size ):
	octree_root = OctreeNode.new(body_size, self)