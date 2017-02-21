extends Spatial

var OctreeNode = global.SCRIPTS.OCTREE_NODE

export(Material) var voxel_material
export(Material) var voxel_material_text

var body_size = 16
var chunk_size = 8
var center = Vector3(0,0,0)
var mass = 0
var octree_root

onready var gravity_area = get_node("gravity_area")

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	# get the relative position of the center body
	var position = get_transform().origin + center
	# for each rigid bodies in the gravity area of the body
	for attracted_body in gravity_area.get_overlapping_bodies():
		if attracted_body extends RigidBody:
			# get the position of the rigid body
			var other_position = attracted_body.get_transform().origin
			# get the distance vector between both
			var difference = position - other_position
			# get the highest coordinate of the distance vector
			var difference_abs = Vector3(abs(difference.x), abs(difference.y), abs(difference.z))
			var max_axis = difference_abs.max_axis()
			# apply gravity to the rigid body according to its position to the body
			var force = Vector3(0,0,0)
			force[max_axis] = 20 * sign(difference[max_axis])
			attracted_body.apply_gravity(other_position, force * delta)

func init( body_size, chunk_size ):
	self.body_size = body_size
	self.chunk_size = chunk_size
	
	mass = body_size * body_size * body_size
	var shape = SphereShape.new()
	shape.set_radius(body_size * 10)
	gravity_area.add_shape(shape)
	
	octree_root = OctreeNode.new(body_size*2, self)
#	octree_root = OctreeNode.new(body_size*chunk_size, self) definitively too computationally intensive
#	octree_root = OctreeNode.new(body_size, self) not enough to display the height generated
	print("octree created")

	# body is radius body_size/2 and height can variate to body_size/4
	var body_max_height = body_size/2 + body_size/4
	var body_diameter = (body_size + body_max_height * 2)
	var body_coord_range = range(-body_diameter/2, body_diameter/2)
	
	octree_root.init_leaves("DEFAULT_INITIALIZER")
#	thread_pool.wait_to_finish()
#	octree_root.init_leaf_random()
	print("leaves chunk initialized")

	octree_root.init_nodes("OCTREE_UPWARD_NAIVE_INITIALIZER")
	print("octree chunks initialized")
	octree_root.generate_mesh()
	print("mesches created")
	octree_root.generate_shapes()
	print("shapes created")
	