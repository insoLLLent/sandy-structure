extends HBoxContainer

var check_box = null
var FPSVideoOptionsItem_node = null
func _ready():
	check_box = $"PanelContainer2/CheckButton"
	check_box.pressed = GlobalOptions.current_vsync
	
	FPSVideoOptionsItem_node = $"../FPSVideoOptionsItem"


func _on_CheckButton_toggled(button_pressed):
	GlobalOptions.settings_vsync(button_pressed)
	FPSVideoOptionsItem_node.update_items()
