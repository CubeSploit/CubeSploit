
var type = global.Voxel_Types.EMPTY
var pos = Vector3(0,0,0)
var face = global.Faces.FRONT
var x = 0
var y = 0
var w = 1
var h = 1

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

func add_to_surface(st, idx, origin):
	var uv_start = float(type-1)/(global.Voxel_Types.COUNT-1)
	var uv_stop = float(type)/(global.Voxel_Types.COUNT-1)

	var v3_mult = Vector3(1,1,1)
	if( face == global.Faces.FRONT || face == global.Faces.BACK ):
		v3_mult = Vector3(w, h, 1)
	if( face == global.Faces.RIGHT || face == global.Faces.LEFT ):
		v3_mult = Vector3(1, h, w)
	if( face == global.Faces.TOP || face == global.Faces.BOTTOM ):
		v3_mult = Vector3(w, 1, h)

	st.add_normal(quads_normals[face])
	st.add_uv( Vector2(0,0) )
	st.add_color( Color(0,uv_start,1-0,uv_stop-uv_start) )
	st.add_vertex(sphericize(quads_vertices[face][0] * v3_mult + pos, origin))
	st.add_uv( Vector2(0,h) )
	st.add_vertex(sphericize(quads_vertices[face][1] * v3_mult + pos, origin))
	st.add_uv( Vector2(w,h) )
	st.add_vertex(sphericize(quads_vertices[face][2] * v3_mult + pos, origin))
	st.add_uv( Vector2(w,0) )
	st.add_vertex(sphericize(quads_vertices[face][3] * v3_mult + pos, origin))

	st.add_index(idx + 0)
	st.add_index(idx + 1)
	st.add_index(idx + 2)
	st.add_index(idx + 0)
	st.add_index(idx + 2)
	st.add_index(idx + 3)
	idx += 4

	return idx

func sphericize(pos, origin):
	pos -= origin
	var max_length = max(abs(pos.x), max(abs(pos.y), abs(pos.z)))
	return pos.normalized() * max_length + origin
