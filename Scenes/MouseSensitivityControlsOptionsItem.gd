extends HBoxContainer


var slider_node = null

func _ready():
	slider_node = $"PanelContainer2/HSlider"
	slider_node.value = GlobalOptions.current_mouse_sensitivity


func _on_HSlider_value_changed(value):
	slider_node.hint_tooltip = str(value)
	GlobalOptions.settings_mouse_sensitivity(value)

