extends HBoxContainer

var check_box = null
var slider_node = null


func _ready():
	check_box = $"PanelContainer/CheckButton"
	slider_node = $"PanelContainer2/HSlider"
	
	check_box.pressed = GlobalOptions.current_mute
	slider_node.value = GlobalOptions.current_volume
	
	slider_node.editable = check_box.pressed


func _on_CheckButton_toggled(button_pressed):
	GlobalOptions.settings_mute(button_pressed)
	slider_node.editable = button_pressed


func _on_HSlider_value_changed(value):
	slider_node.hint_tooltip = str(value) + "dB"
	GlobalOptions.settings_volume(value)
