extends Control

var animation_menu_node = null

func _ready():
	animation_menu_node = $"../animation_menu"
	
	hide()
	set_process(false)


# запускается в скрипте GeneralMenu
func _process(delta):
	if Input.is_action_just_pressed("main_menu_back"):
		if visible:
			if not animation_menu_node.is_playing():
				animation_menu_node.play("NewGameMenu_hide")
				set_process(false)


func _on_InvisibleExitSaveMenuButton_pressed():
	if not animation_menu_node.is_playing():
		animation_menu_node.play("NewGameMenu_hide")
		set_process(false)
	#hide()


func goto_game_scene(location):
	GlobalSave.game_save_remove()
	GlobalData.current_game_mode = GlobalData.GameMode.NEW_GAME
	GlobalData.current_location = location
	NextSceneLoader.goto_scene(GlobalData.GAME_SCENE_RES)


func _on_LocationRandomButton_pressed():
	randomize()
	var location = randi() % GlobalData.GameLocation.size()
	goto_game_scene(location)


func _on_LocationLiteButton_pressed():
	goto_game_scene(GlobalData.GameLocation.LITE)


func _on_LocationDunes01Button_pressed():
	goto_game_scene(GlobalData.GameLocation.DUNES_01)

