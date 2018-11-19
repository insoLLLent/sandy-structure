extends Control


var pause_menu_animation = null
var options_menu_animation = null
var options_menu_game_node = null
var camera_player = null
var ExitBG_node = null

var goto_main_menu = false

var game_node = null
var game_zone_node = null

func _ready():
	hide()
	modulate.a = 0
	pause_menu_animation = $"../../PauseMenuAnimation"
	options_menu_animation = $"../animation_menu"
	options_menu_game_node = $"../OptionsMenuGame"
	camera_player = $"../../CameraPlayer"
	ExitBG_node = $"../ExitBG"
	
	game_node = $"../.."
	game_zone_node = $"../../GameZone"
	
	if ExitBG_node.visible:
		ExitBG_node.hide()
	

var tmp_timer = 0
func _process(delta):
	if goto_main_menu: # перейти в главное меню, но не сразу, чтобы успел отобразиться ExitBG_node
		if tmp_timer > .15:
			NextSceneLoader.goto_scene(GlobalData.MAIN_MENU_SCENE_RES)
		else:
			tmp_timer += delta
		return
	
	if get_tree().paused:
		pause_controller()
		
		if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# пауза
func pause_controller():
	var b = false
	
	if options_menu_game_node.visible:
		return
	
	if Input.is_action_just_pressed("game_pause") or Input.is_action_just_pressed("main_menu_back"):
		if visible:
			animation_unpaused()
		else:
			show()
			pause_menu_animation.play("show")


func animation_unpaused():
	if pause_menu_animation.is_playing():
		return
	else:
		pause_menu_animation.play("hide")


func unpaused():
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_ResumeButton_pressed():
	animation_unpaused()


func _on_OptionsButton_pressed():
	if not options_menu_animation.is_playing():
		options_menu_animation.play("OptionsMenu_show")
		options_menu_game_node.set_process(true)


func _on_SaveAndExitButton_pressed():
	# Save
	GlobalSave.game_save_data(game_node.get_save_data())
	
	# Delayed exit
	unpaused()
	
	if camera_player.environment.adjustment_enabled:
		camera_player.environment.adjustment_saturation = 1
	
	show_exitbg_screen()
	
	goto_main_menu = true


func show_exitbg_screen():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ExitBG_node.show()

