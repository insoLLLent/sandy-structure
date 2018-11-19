extends OptionButton

var lang_list = []

func _enter_tree():
	update_items()


func _on_LanguageOptionButton_item_selected(ID):
	var new_lang = lang_list[ID].abbr
	
	if GlobalOptions.current_language != new_lang or \
	   new_lang == GlobalData.L18N_AUTO:
		GlobalOptions.settings_language(new_lang)
		update_items()


func update_items():
	clear()
	
	update_lang_list()
	
	text = tr("LANGUAGE")
	
	for i in range(lang_list.size()):
		add_item(lang_list[i].locale, i)
		
		if lang_list[i].abbr == GlobalOptions.current_language:
			select(i)


func update_lang_list():
	lang_list.clear()
	
	lang_list = [
		{
			abbr = GlobalData.L18N_AUTO,
			locale = tr("AUTO"),
		}, 
		{
			abbr = GlobalData.L18N_EN,
			locale = tr("ENGLISH"),
		}, 
		{
			abbr = GlobalData.L18N_RU,
			locale = tr("RUSSIAN"),
		},
	]

