extends HBoxContainer

var ssao_list = []

var option_button_node = null

func _ready():
	option_button_node = $"PanelContainer2/OptionButton"
	
	update_items()


func _on_OptionButton_item_selected(ID):
	var new_ssao = ssao_list[ID].abbr
	
	if GlobalOptions.current_ssao != new_ssao:
		GlobalOptions.settings_ssao(new_ssao)
		update_items()


# реакция на изменение языка
func _on_LanguageOptionButton_item_selected(ID):
	update_items()


func update_items():
	option_button_node.clear()
	
	update_ssao_list()
	
	option_button_node.text = tr("SSAO")
	
	for i in range(ssao_list.size()):
		option_button_node.add_item(ssao_list[i].locale, i)
		
		if ssao_list[i].abbr == GlobalOptions.current_ssao:
			option_button_node.select(i)


func update_ssao_list():
	ssao_list.clear()
	
	ssao_list = [
		{
			abbr = GlobalData.EnvironmentSSAO.DISABLED,
			locale = tr("DISABLED"),
		}, 
		{
			abbr = GlobalData.EnvironmentSSAO.LOW,
			locale = tr("LOW"),
		}, 
		{
			abbr = GlobalData.EnvironmentSSAO.MEDIUM,
			locale = tr("MEDIUM"),
		}, 
		{
			abbr = GlobalData.EnvironmentSSAO.HIGH,
			locale = tr("HIGH"),
		},
	]

