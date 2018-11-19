extends Control


var continue_button_node = null
var game_mode_menu_node = null
var options_menu_node = null
var top10_node = null

var animation_menu_node = null


func _ready():
	continue_button_node = $"HBoxContainer/PanelContainer/MarginContainer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/ContinueButton"
	game_mode_menu_node = $"../NewGameMenu"
	options_menu_node = $"../OptionsMenu"
	top10_node = $"../Top10"
	
	animation_menu_node = $"../animation_menu"
	
	continue_button_node.disabled = not GlobalSave.game_save_is_exists()


func _on_ContinueButton_pressed():
	GlobalData.current_game_mode = GlobalData.GameMode.SAVE
	NextSceneLoader.goto_scene(GlobalData.GAME_SCENE_RES)


func _on_NewGameButton_pressed():
	#game_mode_menu_node.show()
	if not animation_menu_node.is_playing():
		animation_menu_node.play("NewGameMenu_show")
		game_mode_menu_node.set_process(true)


func _on_OptionsButton_pressed():
	#options_menu_node.show()
	if not animation_menu_node.is_playing():
		animation_menu_node.play("OptionsMenu_show")
		options_menu_node.set_process(true)


func _on_Top10Button_pressed():
	#top10_node.show()
	if not animation_menu_node.is_playing():
		animation_menu_node.play("Top10_show")
		top10_node.set_process(true)


func _on_ExitButton_pressed():
	get_tree().quit()
