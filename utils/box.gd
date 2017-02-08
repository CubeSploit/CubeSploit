
var type = global.VoxelTypes.EMPTY
var pos = Vector3(0,0,0)
var extents = Vector3(0.5,0.5,0.5)

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

func _init( type, pos, extents ):
	self.type = type
	self.pos = pos
	self.extents = extents
	

func add_to_surface(st, idx, scale):

	idx = add_quad_to_surface(st, idx, scale, global.Faces.FRONT, extents[0]*2, extents[1]*2, extents[2]*2)
	idx = add_quad_to_surface(st, idx, scale, global.Faces.BACK, extents[0]*2, extents[1]*2, extents[2]*2)
	idx = add_quad_to_surface(st, idx, scale, global.Faces.RIGHT, extents[2]*2, extents[1]*2, extents[0]*2)
	idx = add_quad_to_surface(st, idx, scale, global.Faces.LEFT, extents[2]*2, extents[1]*2, extents[0]*2)
	idx = add_quad_to_surface(st, idx, scale, global.Faces.TOP, extents[0]*2, extents[2]*2, extents[1]*2)
	idx = add_quad_to_surface(st, idx, scale, global.Faces.BOTTOM, extents[0]*2, extents[2]*2, extents[1]*2)
	return idx


func add_quad_to_surface(st, idx, scale, face, w, h, l):
	var uv_start = float(type-1)/(global.VoxelTypes.COUNT-1)
	var uv_delta = 1.0/(global.VoxelTypes.COUNT-1)
	
	var v3_mult = Vector3(1,1,1)
	if( face == global.Faces.FRONT || face == global.Faces.BACK ):
		v3_mult = Vector3(w, h, l)
	elif( face == global.Faces.RIGHT || face == global.Faces.LEFT ):
		v3_mult = Vector3(l, h, w)
	elif( face == global.Faces.TOP || face == global.Faces.BOTTOM ):
		v3_mult = Vector3(w, l, h)
	
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
	var size = extents*2
	if !global.shape_cache.has(size):
		var shape_rid = PhysicsServer.shape_create(PhysicsServer.SHAPE_BOX)
		PhysicsServer.shape_set_data(shape_rid, extents)
		global.shape_cache[size] = shape_rid
	
	var transform = Transform()
	transform.origin = offset + pos + extents * scale
	PhysicsServer.body_add_shape(body_rid, global.shape_cache[size], transform)
