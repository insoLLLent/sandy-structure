extends Control

var animation_menu_node = null

var score_label_node_list = []

func _ready():
	animation_menu_node = $"../animation_menu"
	
	for i in range(1, 11):
		score_label_node_list.append(get_node("PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer" + str(i) + "/ScoreLabel"))
		get_node("PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer" + str(i) + "/NumLabel").text = "%2d." % [i]
	
	update_top10()
	
	hide()
	set_process(false)


# запускается в скрипте GeneralMenu
func _process(delta):
	if Input.is_action_just_pressed("game_skip_intro"):
		if visible:
			if not animation_menu_node.is_playing():
				animation_menu_node.play("Top10_hide")
				set_process(false)


# подгрузить результаты, используется в AnimationPlayer
func update_top10():
	for i in range(10):
		score_label_node_list[i].text = str(GlobalTop10.current_top10[i])

