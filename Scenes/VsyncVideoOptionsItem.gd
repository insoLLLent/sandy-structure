extends HBoxContainer

var check_box = null
var FPSVideoOptionsItem_node = null


func _ready():
	check_box = $"PanelContainer2/CheckButton"
	FPSVideoOptionsItem_node = $"../FPSVideoOptionsItem"
	
	update_items()


func _on_CheckButton_toggled(button_pressed):
	GlobalOptions.settings_vsync(button_pressed)
	FPSVideoOptionsItem_node.update_items()
	
	GlobalOptions.settings_quality(GlobalData.QualitySettings.CUSTOM)
	$"../QualitySettingsVideoOptionsItem".update_items()


func update_items():
	check_box.pressed = GlobalOptions.current_vsync
