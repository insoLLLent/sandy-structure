extends HBoxContainer

var check_button_node = null

func _ready():
	check_button_node = $"PanelContainer2/CheckButton"
	check_button_node.pressed = GlobalOptions.current_shadow_enabled


func _on_CheckButton_toggled(button_pressed):
	GlobalOptions.settings_shadow_enabled(button_pressed)

