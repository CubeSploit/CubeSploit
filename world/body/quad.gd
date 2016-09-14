
var type
var pos
var face
var x
var y
var w
var h

const quads_vertices = [
	[Vector3(0,0,1), Vector3(0,1,1), Vector3(1,1,1), Vector3(1,0,1)], # front
	[Vector3(1,0,0), Vector3(1,1,0), Vector3(0,1,0), Vector3(0,0,0)], # back
	[Vector3(1,0,1), Vector3(1,1,1), Vector3(1,1,0), Vector3(1,0,0)], # right
	[Vector3(0,0,0), Vector3(0,1,0), Vector3(0,1,1), Vector3(0,0,1)], # left
	[Vector3(0,1,1), Vector3(0,1,0), Vector3(1,1,0), Vector3(1,1,1)], # top
	[Vector3(0,0,0), Vector3(0,0,1), Vector3(1,0,1), Vector3(1,0,0)] # bottom
]
const quads_normals = [
	Vector3(0,0,1), # front
	Vector3(0,0,-1), # back
	Vector3(1,0,0), # right
	Vector3(-1,0,0), # left
	Vector3(0,1,0), # top
	Vector3(0,-1,0) # bottom
]

func _init( type, pos, face, x, y, w, h ):
	self.type = type
	self.pos = pos
	self.face = face
	self.x = x
	self.y = y
	self.w = w
	self.h = h

func add_to_surface(st, idx):
	var uv_start = float(type-1)/(global.voxel_types.count-1)
	var uv_stop = float(type)/(global.voxel_types.count-1)

	var v3_mult = Vector3(1,1,1)
	if( face == global.faces.front || face == global.faces.back ):
		v3_mult = Vector3(w, h, 1)
	if( face == global.faces.right || face == global.faces.left ):
		v3_mult = Vector3(1, h, w)
	if( face == global.faces.top || face == global.faces.bottom ):
		v3_mult = Vector3(w, 1, h)

	st.add_normal(quads_normals[face])
	st.add_uv( Vector2(0, uv_start ) )
	st.add_vertex(quads_vertices[face][0] * v3_mult + pos)
	st.add_uv( Vector2(0, uv_stop ) )
	st.add_vertex(quads_vertices[face][1] * v3_mult + pos)
	st.add_uv( Vector2(1, uv_stop ) )
	st.add_vertex(quads_vertices[face][2] * v3_mult + pos)
	st.add_uv( Vector2(1, uv_start ) )
	st.add_vertex(quads_vertices[face][3] * v3_mult + pos)

	st.add_index(idx + 0)
	st.add_index(idx + 1)
	st.add_index(idx + 2)
	st.add_index(idx + 0)
	st.add_index(idx + 2)
	st.add_index(idx + 3)
	idx += 4

	return idx
