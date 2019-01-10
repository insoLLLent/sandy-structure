extends Node

#######################

enum {
	EMPTY,
	SINGLE,
	SINGLECOLUMN_FRONT_BOTTOM,
	SINGLECOLUMN_FRONT_CENTER,
	SINGLECOLUMN_FRONT_TOP,
}

var cubes = {}

#######################

func _enter_tree():
	load_cube_view()


# загрузить сцены кубов в соответствии с текущей картой
# (также, запускается по сигналу из скрипта Game)
func load_cube_view():
	cubes.clear()
	cubes[EMPTY] = null
	
	match GlobalData.current_location:
		GlobalData.GameLocation.LITE:
			#load_lite()
			load_dunes_01()
		GlobalData.GameLocation.DUNES_01:
			load_dunes_01()
		_:
			#load_lite()
			load_dunes_01()


func load_lite():
	cubes[SINGLE] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single.tscn")
	
	cubes[SINGLECOLUMN_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleColumn_Front_Bottom.tscn")
	cubes[SINGLECOLUMN_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleColumn_Front_Center.tscn")
	cubes[SINGLECOLUMN_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleColumn_Front_Top.tscn")


func load_dunes_01():
	cubes[SINGLE] = load("res://Prefabs/ZoneCubes/Dunes_01/ZC_Dunes_01_Single.tscn")
	
	cubes[SINGLECOLUMN_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Dunes_01/ZC_Dunes_01_SingleColumn_Front_Bottom.tscn")
	cubes[SINGLECOLUMN_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Dunes_01/ZC_Dunes_01_SingleColumn_Front_Center.tscn")
	cubes[SINGLECOLUMN_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Dunes_01/ZC_Dunes_01_SingleColumn_Front_Top.tscn")

