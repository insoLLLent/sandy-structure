extends Control

var dead_end_animation_node = null
var counter_score_node = null

func _ready():
	dead_end_animation_node = $"../../DeadEndAnimation"
	counter_score_node = $"PanelContainer/CenterContainer/VBoxContainer/HBoxContainer/CounterLabel"
	hide()


func show_dead_end():
	if not dead_end_animation_node.is_playing():
		dead_end_animation_node.play("DeadEndScreen_show")


func goto_main_menu():
	NextSceneLoader.goto_scene(GlobalData.MAIN_MENU_SCENE_RES)


func _on_Game_update_score_sig(current_score):
	counter_score_node.text = str(current_score)
