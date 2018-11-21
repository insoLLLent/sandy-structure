extends HBoxContainer

var quality_list = []

var option_button_node = null

func _ready():
	option_button_node = $"PanelContainer2/OptionButton"
	
	update_items()


func _on_OptionButton_item_selected(ID):
	var new_quality = quality_list[ID].abbr
	
	if new_quality == GlobalData.QualitySettings.CUSTOM:
		update_items()
		return
	
	if GlobalOptions.current_quality != new_quality:
		GlobalOptions.settings_quality(new_quality)
		update_items()
		
		$"../VsyncVideoOptionsItem".update_items()
		$"../MSAAVideoOptionsItem".update_items()
		$"../SSAOVideoOptionsItem".update_items()
		$"../ShadowEnabledVideoOptionsItem".update_items()


# реакция на изменение языка
func _on_LanguageOptionButton_item_selected(ID):
	update_items()


func update_items():
	option_button_node.clear()
	
	update_quality_list()
	
	option_button_node.text = tr("QUALITY_SETTINGS")
	
	for i in range(quality_list.size()):
		option_button_node.add_item(quality_list[i].locale, i)
		
		if quality_list[i].abbr == GlobalOptions.current_quality:
			option_button_node.select(i)


func update_quality_list():
	quality_list.clear()
	
	quality_list = [
		{
			abbr = GlobalData.QualitySettings.CUSTOM,
			locale = tr("QUALITY_CUSTOM"),
		}, 
		{
			abbr = GlobalData.QualitySettings.LOW,
			locale = tr("QUALITY_LOW"),
		}, 
		{
			abbr = GlobalData.QualitySettings.MEDIUM,
			locale = tr("QUALITY_MEDIUM"),
		}, 
		{
			abbr = GlobalData.QualitySettings.HIGH,
			locale = tr("QUALITY_HIGH"),
		},
	]

