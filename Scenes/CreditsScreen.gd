extends Control

var animation_menu_node = null

func _ready():
	animation_menu_node = $"../animation_menu"
	
	hide()
	set_process(false)


# запускается в скрипте GeneralMenu
func _process(delta):
	if Input.is_action_just_pressed("game_skip_intro"):
		if visible:
			if not animation_menu_node.is_playing():
				animation_menu_node.play("CreditsScreen_hide")
				set_process(false)

