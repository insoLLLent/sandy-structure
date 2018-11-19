extends Spatial

var current_cube_inst = null
var current_cube = null

func _ready():
	load_cube_view()
	
	current_cube = current_cube_inst.instance()
	add_child(current_cube)


# загрузить сцены кубов в соответствии с текущей картой
func load_cube_view():
	match GlobalData.current_location:
		GlobalData.GameLocation.LITE:
			current_cube_inst = load("res://Prefabs/FallZoneCube/FallZoneCube_Lite.tscn")
		GlobalData.GameLocation.DUNES_01:
			current_cube_inst = load("res://Prefabs/FallZoneCube/FallZoneCube_Dunes_01.tscn")
		_:
			current_cube_inst = load("res://Prefabs/FallZoneCube/FallZoneCube_Lite.tscn")
