extends HBoxContainer

var check_button_node = null

func _ready():
	check_button_node = $"PanelContainer2/CheckButton"
	
	update_items()



func _on_CheckButton_toggled(button_pressed):
	GlobalOptions.settings_shadow_enabled(button_pressed)
	
	GlobalOptions.settings_quality(GlobalData.QualitySettings.CUSTOM)
	$"../QualitySettingsVideoOptionsItem".update_items()


func update_items():
	check_button_node.pressed = GlobalOptions.current_shadow_enabled
