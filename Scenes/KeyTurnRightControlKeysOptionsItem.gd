extends HBoxContainer

var button_node = null

var wait_for_input = false

func _ready():
	button_node = $"PanelContainer2/Button"
	button_node.text = GlobalOptions.current_key_change_pose_next
	set_process_input(false)


func _input(event):
	if wait_for_input:
		if event.is_pressed():
			if (event is InputEventKey) and \
			   (event.scancode != InputMap.get_action_list("main_menu_back")[0].scancode):
				
				var new_scancode = OS.get_scancode_string(event.scancode)
				GlobalOptions.settings_key_change_pose_next(new_scancode)
			
			wait_for_input = false
			button_node.text = GlobalOptions.current_key_change_pose_next
			button_node.pressed = false
			set_process_input(false)


func _on_Button_toggled(button_pressed):
	if button_pressed:
		button_node.text = tr("PRESS_ANY_KEY")
		wait_for_input = true
		set_process_input(true)
	else:
		wait_for_input = false
		button_node.text = GlobalOptions.current_key_change_pose_next

