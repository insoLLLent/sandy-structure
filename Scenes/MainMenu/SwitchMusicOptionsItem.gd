extends HBoxContainer


var check_box = null

func _ready():
	check_box = $"PanelContainer/CheckButton"
	check_box.pressed = GlobalOptions.current_music_mute


func _on_CheckButton_toggled(button_pressed):
	GlobalOptions.settings_music_mute(button_pressed)
