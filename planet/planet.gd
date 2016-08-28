
extends MeshInstance


var voxels = {}
var dirty = false
var voxel_colors = {
	1: Color(1,0,0),
	2: Color(0,1,0),
	3: Color(0,0,1),
}

const FACES = {
	Vector3(0,0,1): [Vector3(1,1,1), Vector3(1,0,1), Vector3(0,0,1), Vector3(0,1,1)],
	Vector3(0,0,-1): [Vector3(1,1,0), Vector3(0,1,0), Vector3(0,0,0), Vector3(1,0,0)],
	Vector3(0,1,0): [Vector3(1,1,1), Vector3(0,1,1), Vector3(0,1,0), Vector3(1,1,0)],
	Vector3(0,-1,0): [Vector3(1,0,1), Vector3(1,0,0), Vector3(0,0,0), Vector3(0,0,1)],
	Vector3(1,0,0): [Vector3(1,1,1), Vector3(1,1,0), Vector3(1,0,0), Vector3(1,0,1)],
	Vector3(-1,0,0): [Vector3(0,1,1), Vector3(0,0,1), Vector3(0,0,0), Vector3(0,1,0)]
}

func _ready():
	
	var r = 10
	var offset = Vector3(0,0,0)
	
	for x in range(0,r):
		for y in range(0,r):
			for z in range(0,r):
				set_voxel(Vector3(x,y,z) + offset, randi()%3 +1)
	
	set_process_input(true)



func set_voxel(_position, type):
	var position = _position.snapped(1)
	if type != 0:
		voxels[position] = type
	else:
		voxels.erase(position)
	if !dirty:
		dirty = true
		call_deferred("draw")

func draw():
	print("drawing...")
	var tools = {}
	var tools_indices = {}
	var materials = {}
	var mesh = Mesh.new()
	
	for type in voxel_colors:
		var material = FixedMaterial.new()
		var st = SurfaceTool.new()
		material.set_parameter(material.PARAM_DIFFUSE, voxel_colors[type])
		material.set_parameter(material.PARAM_SPECULAR, Color(1,1,1))
		material.set_flag(material.FLAG_DOUBLE_SIDED, true)
		st.set_material(material)
		st.begin(VisualServer.PRIMITIVE_TRIANGLES)
		tools[type] = st
		tools_indices[type] = 0
	
	for pos in voxels:
		var type = voxels[pos]
		var st = tools[type]
		var idx = tools_indices[type]
		
		for normal in FACES:
			if !voxels.has((pos + normal)):
			#if !voxels.has(pos + normal):
				idx = draw_face(st, pos, normal, idx)
		
		tools_indices[type] = idx
	
	for type in tools:
		var st = tools[type]
		st.index()
		mesh = st.commit(mesh)
	
	set_mesh(mesh)

func draw_face(st, pos, normal, idx):
	var coords = FACES[normal]
	st.add_normal(normal)
	
	st.add_uv(Vector2(0,0))
	st.add_vertex(pos + coords[0])
	st.add_uv(Vector2(0,1))
	st.add_vertex(pos + coords[1])
	st.add_uv(Vector2(1,1))
	st.add_vertex(pos + coords[2])
	st.add_uv(Vector2(1,0))
	st.add_vertex(pos + coords[3])
	
	st.add_index(idx + 0)
	st.add_index(idx + 1)
	st.add_index(idx + 2)
	st.add_index(idx + 0)
	st.add_index(idx + 2)
	st.add_index(idx + 3)
	idx += 4
	
	return idx
