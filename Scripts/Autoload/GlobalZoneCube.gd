extends Node

#######################

enum {
	EMPTY,
	SINGLE,
	SINGLECOLUMN_FRONT_BOTTOM,
	SINGLECOLUMN_FRONT_CENTER,
	SINGLECOLUMN_FRONT_TOP,
	SINGLE_BACK_BOTTOM,
	SINGLE_BACK_CENTER,
	SINGLE_BACK_TOP,
	SINGLE_CENTER_BOTTOM,
	SINGLE_CENTER_CENTER,
	SINGLE_CENTER_TOP,
	SINGLE_FRONT_BOTTOM,
	SINGLE_FRONT_CENTER,
	SINGLE_FRONT_TOP,
	SINGLEROT_BACK_BOTTOM,
	SINGLEROT_BACK_CENTER,
	SINGLEROT_BACK_TOP,
	SINGLEROT_CENTER_BOTTOM,
	SINGLEROT_CENTER_CENTER,
	SINGLEROT_CENTER_TOP,
	SINGLEROT_FRONT_BOTTOM,
	SINGLEROT_FRONT_CENTER,
	SINGLEROT_FRONT_TOP,
	RIGHT_FRONT_TOP,
	CENTER_FRONT_TOP,
	LEFT_FRONT_TOP,
	RIGHT_FRONT_CENTER,
	CENTER_FRONT_CENTER,
	LEFT_FRONT_CENTER,
	RIGHT_FRONT_BOTTOM,
	CENTER_FRONT_BOTTOM,
	LEFT_FRONT_BOTTOM,
	RIGHT_CENTER_TOP,
	CENTER_CENTER_TOP,
	LEFT_CENTER_TOP,
	RIGHT_CENTER_CENTER,
	CENTER_CENTER_CENTER,
	LEFT_CENTER_CENTER,
	RIGHT_CENTER_BOTTOM,
	CENTER_CENTER_BOTTOM,
	LEFT_CENTER_BOTTOM,
	RIGHT_BACK_TOP,
	CENTER_BACK_TOP,
	LEFT_BACK_TOP,
	RIGHT_BACK_CENTER,
	CENTER_BACK_CENTER,
	LEFT_BACK_CENTER,
	RIGHT_BACK_BOTTOM,
	CENTER_BACK_BOTTOM,
	LEFT_BACK_BOTTOM,
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
			load_lite()
		GlobalData.GameLocation.DUNES_01:
			load_dunes_01()
		_:
			load_lite()


func load_lite():
	cubes[SINGLE] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single.tscn")
	
	cubes[SINGLECOLUMN_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleColumn_Front_Bottom.tscn")
	cubes[SINGLECOLUMN_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleColumn_Front_Center.tscn")
	cubes[SINGLECOLUMN_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleColumn_Front_Top.tscn")
	
	cubes[SINGLE_BACK_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Back_Bottom.tscn")
	cubes[SINGLE_BACK_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Back_Center.tscn")
	cubes[SINGLE_BACK_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Back_Top.tscn")
	
	cubes[SINGLE_CENTER_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Center_Bottom.tscn")
	cubes[SINGLE_CENTER_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Center_Center.tscn")
	cubes[SINGLE_CENTER_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Center_Top.tscn")
	
	cubes[SINGLE_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Front_Bottom.tscn")
	cubes[SINGLE_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Front_Center.tscn")
	cubes[SINGLE_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Front_Top.tscn")
	
	cubes[SINGLEROT_BACK_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Back_Bottom.tscn")
	cubes[SINGLEROT_BACK_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Back_Center.tscn")
	cubes[SINGLEROT_BACK_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Back_Top.tscn")
	
	cubes[SINGLEROT_CENTER_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Center_Bottom.tscn")
	cubes[SINGLEROT_CENTER_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Center_Center.tscn")
	cubes[SINGLEROT_CENTER_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Center_Top.tscn")
	
	cubes[SINGLEROT_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Front_Bottom.tscn")
	cubes[SINGLEROT_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Front_Center.tscn")
	cubes[SINGLEROT_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Front_Top.tscn")
	
	cubes[RIGHT_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Front_Top.tscn")
	cubes[CENTER_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Front_Top.tscn")
	cubes[LEFT_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Front_Top.tscn")
	
	cubes[RIGHT_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Front_Center.tscn")
	cubes[CENTER_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Front_Center.tscn")
	cubes[LEFT_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Front_Center.tscn")
	
	cubes[RIGHT_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Front_Bottom.tscn")
	cubes[CENTER_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Front_Bottom.tscn")
	cubes[LEFT_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Front_Bottom.tscn")
	
	cubes[RIGHT_CENTER_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Center_Top.tscn")
	cubes[CENTER_CENTER_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Center_Top.tscn")
	cubes[LEFT_CENTER_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Center_Top.tscn")
	
	cubes[RIGHT_CENTER_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Center_Center.tscn")
	cubes[CENTER_CENTER_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Center_Center.tscn")
	cubes[LEFT_CENTER_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Center_Center.tscn")
	
	cubes[RIGHT_CENTER_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Center_Bottom.tscn")
	cubes[CENTER_CENTER_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Center_Bottom.tscn")
	cubes[LEFT_CENTER_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Center_Bottom.tscn")
	
	cubes[RIGHT_BACK_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Back_Top.tscn")
	cubes[CENTER_BACK_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Back_Top.tscn")
	cubes[LEFT_BACK_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Back_Top.tscn")
	
	cubes[RIGHT_BACK_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Back_Center.tscn")
	cubes[CENTER_BACK_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Back_Center.tscn")
	cubes[LEFT_BACK_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Back_Center.tscn")
	
	cubes[RIGHT_BACK_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Back_Bottom.tscn")
	cubes[CENTER_BACK_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Back_Bottom.tscn")
	cubes[LEFT_BACK_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Back_Bottom.tscn")


func load_dunes_01():
	cubes[SINGLE] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single.tscn")
	
	cubes[SINGLECOLUMN_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleColumn_Front_Bottom.tscn")
	cubes[SINGLECOLUMN_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleColumn_Front_Center.tscn")
	cubes[SINGLECOLUMN_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleColumn_Front_Top.tscn")
	
	cubes[SINGLE_BACK_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Back_Bottom.tscn")
	cubes[SINGLE_BACK_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Back_Center.tscn")
	cubes[SINGLE_BACK_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Back_Top.tscn")
	
	cubes[SINGLE_CENTER_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Center_Bottom.tscn")
	cubes[SINGLE_CENTER_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Center_Center.tscn")
	cubes[SINGLE_CENTER_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Center_Top.tscn")
	
	cubes[SINGLE_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Front_Bottom.tscn")
	cubes[SINGLE_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Front_Center.tscn")
	cubes[SINGLE_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Single_Front_Top.tscn")
	
	cubes[SINGLEROT_BACK_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Back_Bottom.tscn")
	cubes[SINGLEROT_BACK_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Back_Center.tscn")
	cubes[SINGLEROT_BACK_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Back_Top.tscn")
	
	cubes[SINGLEROT_CENTER_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Center_Bottom.tscn")
	cubes[SINGLEROT_CENTER_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Center_Center.tscn")
	cubes[SINGLEROT_CENTER_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Center_Top.tscn")
	
	cubes[SINGLEROT_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Front_Bottom.tscn")
	cubes[SINGLEROT_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Front_Center.tscn")
	cubes[SINGLEROT_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_SingleRot_Front_Top.tscn")
	
	cubes[RIGHT_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Front_Top.tscn")
	cubes[CENTER_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Front_Top.tscn")
	cubes[LEFT_FRONT_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Front_Top.tscn")
	
	cubes[RIGHT_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Front_Center.tscn")
	cubes[CENTER_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Front_Center.tscn")
	cubes[LEFT_FRONT_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Front_Center.tscn")
	
	cubes[RIGHT_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Front_Bottom.tscn")
	cubes[CENTER_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Front_Bottom.tscn")
	cubes[LEFT_FRONT_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Front_Bottom.tscn")
	
	cubes[RIGHT_CENTER_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Center_Top.tscn")
	cubes[CENTER_CENTER_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Center_Top.tscn")
	cubes[LEFT_CENTER_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Center_Top.tscn")
	
	cubes[RIGHT_CENTER_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Center_Center.tscn")
	cubes[CENTER_CENTER_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Center_Center.tscn")
	cubes[LEFT_CENTER_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Center_Center.tscn")
	
	cubes[RIGHT_CENTER_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Center_Bottom.tscn")
	cubes[CENTER_CENTER_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Center_Bottom.tscn")
	cubes[LEFT_CENTER_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Center_Bottom.tscn")
	
	cubes[RIGHT_BACK_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Back_Top.tscn")
	cubes[CENTER_BACK_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Back_Top.tscn")
	cubes[LEFT_BACK_TOP] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Back_Top.tscn")
	
	cubes[RIGHT_BACK_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Back_Center.tscn")
	cubes[CENTER_BACK_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Back_Center.tscn")
	cubes[LEFT_BACK_CENTER] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Back_Center.tscn")
	
	cubes[RIGHT_BACK_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Right_Back_Bottom.tscn")
	cubes[CENTER_BACK_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Center_Back_Bottom.tscn")
	cubes[LEFT_BACK_BOTTOM] = load("res://Prefabs/ZoneCubes/Lite/ZC_Lite_Left_Back_Bottom.tscn")

