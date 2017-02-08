
var type = global.VoxelTypes.EMPTY
var pos = Vector3(0,0,0)
var face = global.Faces.FRONT
var w = 1
var h = 1

const quads_vertices = [
	[Vector3(0,0,1), Vector3(0,1,1), Vector3(1,1,1), Vector3(1,0,1)], # Front
	[Vector3(1,0,0), Vector3(1,1,0), Vector3(0,1,0), Vector3(0,0,0)], # Back
	[Vector3(1,0,1), Vector3(1,1,1), Vector3(1,1,0), Vector3(1,0,0)], # Right
	[Vector3(0,0,0), Vector3(0,1,0), Vector3(0,1,1), Vector3(0,0,1)], # Left
	[Vector3(0,1,1), Vector3(0,1,0), Vector3(1,1,0), Vector3(1,1,1)], # Top
	[Vector3(0,0,0), Vector3(0,0,1), Vector3(1,0,1), Vector3(1,0,0)] # Bottom
]
const quads_normals = [
	Vector3(0,0,1), # Front
	Vector3(0,0,-1), # Back
	Vector3(1,0,0), # Right
	Vector3(-1,0,0), # Left
	Vector3(0,1,0), # Top
	Vector3(0,-1,0) # Bottom
]

func _init( type, pos, face, w, h ):
	self.type = type
	self.pos = pos
	self.face = face
	self.w = w
	self.h = h

func add_to_surface(st, idx, scale):
	var uv_start = float(type-1)/(global.VoxelTypes.COUNT-1)
	var uv_delta = 1.0/(global.VoxelTypes.COUNT-1)
	
	var v3_mult = Vector3(1,1,1)
	if( face == global.Faces.FRONT || face == global.Faces.BACK ):
		v3_mult = Vector3(w, h, 1)
	elif( face == global.Faces.RIGHT || face == global.Faces.LEFT ):
		v3_mult = Vector3(1, h, w)
	elif( face == global.Faces.TOP || face == global.Faces.BOTTOM ):
		v3_mult = Vector3(w, 1, h)
	
	st.add_normal(quads_normals[face])
	st.add_uv( Vector2(0,0) * scale )
	st.add_color( Color(0,uv_start,1, uv_delta) )
	st.add_vertex(quads_vertices[face][0] * v3_mult + pos)
	st.add_uv( Vector2(0,h) * scale )
	st.add_vertex(quads_vertices[face][1] * v3_mult + pos)
	st.add_uv( Vector2(w,h) * scale )
	st.add_vertex(quads_vertices[face][2] * v3_mult + pos)
	st.add_uv( Vector2(w,0) * scale )
	st.add_vertex(quads_vertices[face][3] * v3_mult + pos)

	st.add_index(idx + 0)
	st.add_index(idx + 1)
	st.add_index(idx + 2)
	st.add_index(idx + 0)
	st.add_index(idx + 2)
	st.add_index(idx + 3)
	idx += 4

	return idx

func add_to_body(body_rid, offset, scale):
	var v3_mult = Vector3(1,1,1)
	var rotate_axis = Vector3(0,0,0)
	var rot_value = 0
	if( face == global.Faces.FRONT || face == global.Faces.BACK ):
		v3_mult = Vector3(w, h, 1)
	elif( face == global.Faces.RIGHT || face == global.Faces.LEFT ):
		v3_mult = Vector3(1, h, w)
		rotate_axis = Vector3(0,1,0)
		rot_value = PI/2
	elif( face == global.Faces.TOP || face == global.Faces.BOTTOM ):
		v3_mult = Vector3(w, 1, h)
		rotate_axis = Vector3(1,0,0)
		rot_value = PI/2
	
	var size = Vector3(w, h, 1) * scale
	
	if !global.shape_cache.has(size):
		var shape_rid = PhysicsServer.shape_create(PhysicsServer.SHAPE_BOX)
		PhysicsServer.shape_set_data(shape_rid, size / 2)
		global.shape_cache[size] = shape_rid
	
	var transform = Transform().rotated(rotate_axis, rot_value)
	transform.origin = offset + pos + v3_mult / 2 * scale
	PhysicsServer.body_add_shape(body_rid, global.shape_cache[size], transform)
