extends HBoxContainer

var fps_list = []

var option_button_node = null

func _ready():
	option_button_node = $"./PanelContainer2/OptionButton"
	update_items()


func _on_OptionButton_item_selected(ID):
	var new_fps = fps_list[ID].abbr
	
	if GlobalOptions.current_vsync and new_fps > GlobalData.FPS_60:
		new_fps = GlobalData.FPS_60
	
	if GlobalOptions.current_fps != new_fps:
		GlobalOptions.settings_fps(new_fps)
	
	update_items()
	
	GlobalOptions.settings_quality(GlobalData.QualitySettings.CUSTOM)
	$"../QualitySettingsVideoOptionsItem".update_items()


# реакция на изменение языка
func _on_LanguageOptionButton_item_selected(ID):
	update_items()


func update_items():
	if option_button_node == null:
		return
	
	option_button_node.clear()
	
	update_fps_list()
	
	option_button_node.text = tr("FPS")
	
	for i in range(fps_list.size()):
		option_button_node.add_item(fps_list[i].locale, i)
		
		if fps_list[i].abbr == GlobalOptions.current_fps:
			option_button_node.select(i)


func update_fps_list():
	fps_list.clear()
	
	fps_list = [
		{
			abbr = GlobalData.FPS_30,
			locale = str(GlobalData.FPS_30),
		}, 
		{
			abbr = GlobalData.FPS_60,
			locale = str(GlobalData.FPS_60),
		}, 
		{
			abbr = GlobalData.FPS_90,
			locale = str(GlobalData.FPS_90),
		}, 
		{
			abbr = GlobalData.FPS_120,
			locale = str(GlobalData.FPS_120),
		},
	]
