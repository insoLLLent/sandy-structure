extends Node

var animation_path = "IntroLabelAnimation"
var animation_node = null


func _ready():
	animation_node = get_node(animation_path)


func _process(delta):
	if not animation_node.is_playing():
		animation_node.play("show")
		set_process(false)


func _input(event):
	if Input.is_action_pressed("game_skip_intro"):
		animation_node.stop()
		goto_main_menu_scene()


# Используется для перехода в главное меню
# Также, используется в анимации animation_path
func goto_main_menu_scene():
	NextSceneLoader.goto_scene(GlobalData.MAIN_MENU_SCENE_RES)

