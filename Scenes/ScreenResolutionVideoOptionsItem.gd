extends HBoxContainer

var screen_sizes_list = []

var option_button_node = null

func _ready():
	option_button_node = $"PanelContainer2/OptionButton"
	
	update_items()


func _on_OptionButton_item_selected(ID):
	var new_screen_size = screen_sizes_list[ID].abbr
	
	if GlobalOptions.current_screen_size != new_screen_size or \
	   new_screen_size == GlobalData.SCREEN_SIZES[GlobalData.SCREEN_SIZE_AUTO]:
		GlobalOptions.settings_screen_size(new_screen_size)
		update_items()
		
		GlobalOptions.settings_quality(GlobalData.QualitySettings.CUSTOM)
		$"../QualitySettingsVideoOptionsItem".update_items()


# реакция на изменение языка
func _on_LanguageOptionButton_item_selected(ID):
	update_items()


func update_items():
	option_button_node.clear()
	
	update_screen_sizes_list()
	
	option_button_node.text = tr("SCREEN_SIZES")
	
	for i in range(screen_sizes_list.size()):
		option_button_node.add_item(screen_sizes_list[i].locale, i)
		
		if screen_sizes_list[i].abbr == GlobalOptions.current_screen_size:
			option_button_node.select(i)


func update_screen_sizes_list():
	screen_sizes_list.clear()
	
	for key in GlobalData.SCREEN_SIZES.keys():
		if key == GlobalData.SCREEN_SIZE_AUTO:
			screen_sizes_list.append({
				"abbr": GlobalData.SCREEN_SIZES[key],
				"locale": tr("AUTO"),
			})
			continue
		
		screen_sizes_list.append({
			"abbr": GlobalData.SCREEN_SIZES[key],
			"locale": key,
		})

