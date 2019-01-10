extends Spatial

const COUNT_MATERIALS = 3

var current_cube_inst = null
var current_cube = null


func _ready():
	_load_cube_view()
	current_cube = current_cube_inst.instance()
	add_child(current_cube)


func _process(delta):
	_send_pause_to_material(get_tree().paused)


# загрузить сцены кубов в соответствии с текущей картой
func _load_cube_view():
	match GlobalData.current_location:
		GlobalData.GameLocation.LITE:
			#current_cube_inst = load("res://Prefabs/Figures/SingleCube/LiteCube.tscn")
			current_cube_inst = load("res://Prefabs/Figures/SingleCube/Dunes01Cube.tscn")
		GlobalData.GameLocation.DUNES_01:
			current_cube_inst = load("res://Prefabs/Figures/SingleCube/Dunes01Cube.tscn")
		_:
			#current_cube_inst = load("res://Prefabs/Figures/SingleCube/LiteCube.tscn")
			current_cube_inst = load("res://Prefabs/Figures/SingleCube/Dunes01Cube.tscn")



# отправить состояние паузы в материал
func _send_pause_to_material(pause):
	for current_cube_child in current_cube.get_children():
		if current_cube_child != null and GlobalFunctions.exists_node(current_cube_child):
			if current_cube_child is MeshInstance:
				for i in range(COUNT_MATERIALS):
					var mat = current_cube_child.get_surface_material(i)
					if mat != null and mat.has_method("set_pause_material"):
						mat.set_pause_material(pause)

