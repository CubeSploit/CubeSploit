extends Spatial

var OctreeNode = global.SCRIPTS.OCTREE_NODE

export(Material) var voxel_material
export(Material) var voxel_material_text

var chunk_size = 8
var chunks = [] # 3D array containing the chunks of the body
var center = Vector3()
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

func generate_random_octree( body_size ):
	octree_root = OctreeNode.new(body_size, self)
	center = Vector3(1,1,1) * body_size / 2
	mass = body_size * body_size * body_size
	
	var shape = SphereShape.new()
	shape.set_radius(body_size * 10)
	gravity_area.add_shape(shape)
