extends Control


var video_panel_container_node = null
var music_panel_container_node = null
var controls_panel_container_node = null
var animation_menu_node = null


func _ready():
	animation_menu_node = $"../animation_menu"
	
	hide()
	
	video_panel_container_node = $"PanelContainer/HBoxContainer/VideoPanelContainer"
	music_panel_container_node = $"PanelContainer/HBoxContainer/MusicPanelContainer"
	controls_panel_container_node = $"PanelContainer/HBoxContainer/ControlsPanelContainer"
	
	video_panel_container_node.show()
	music_panel_container_node.hide()
	controls_panel_container_node.hide()
	
	set_process(false)


# запускается в скрипте GeneralMenu и PauseMenu
func _process(delta):
	if Input.is_action_just_pressed("main_menu_back"):
		if visible:
			if not animation_menu_node.is_playing():
				animation_menu_node.play("OptionsMenu_hide")
				set_process(false)


func _on_InvisibleExitSaveMenuButton_pressed():
	if not animation_menu_node.is_playing():
		animation_menu_node.play("OptionsMenu_hide")
		set_process(false)
	#hide()


func _on_VideoButton_pressed():
	video_panel_container_node.show()
	music_panel_container_node.hide()
	controls_panel_container_node.hide()


func _on_MusicButton_pressed():
	video_panel_container_node.hide()
	music_panel_container_node.show()
	controls_panel_container_node.hide()


func _on_ControlsButton_pressed():
	video_panel_container_node.hide()
	music_panel_container_node.hide()
	controls_panel_container_node.show()
