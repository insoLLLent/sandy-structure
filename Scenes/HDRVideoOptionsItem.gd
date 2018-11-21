extends HBoxContainer

var check_box = null


func _ready():
	check_box = $"PanelContainer2/CheckButton"
	check_box.pressed = GlobalOptions.current_hdr


func _on_CheckButton_toggled(button_pressed):
	GlobalOptions.settings_hdr(button_pressed)
	
	GlobalOptions.settings_quality(GlobalData.QualitySettings.CUSTOM)
	$"../QualitySettingsVideoOptionsItem".update_items()
