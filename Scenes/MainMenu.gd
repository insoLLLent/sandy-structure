extends Node

func _ready():
	GlobalData.current_game_mode = GlobalData.GameMode.NEW_GAME
	GlobalData.current_location = GlobalData.GameLocation.LITE
	
	get_tree().paused = false
	
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	GlobalOptions.settings_shadow_enabled()
