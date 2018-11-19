extends HBoxContainer

var msaa_list = []

var option_button_node = null

func _ready():
	option_button_node = $"PanelContainer2/OptionButton"
	
	update_items()


func _on_OptionButton_item_selected(ID):
	var new_msaa = msaa_list[ID].abbr
	
	if GlobalOptions.current_msaa != new_msaa:
		GlobalOptions.settings_msaa(new_msaa)
		update_items()


# реакция на изменение языка
func _on_LanguageOptionButton_item_selected(ID):
	update_items()


func update_items():
	option_button_node.clear()
	
	update_msaa_list()
	
	option_button_node.text = tr("MSAA")
	
	for i in range(msaa_list.size()):
		option_button_node.add_item(msaa_list[i].locale, i)
		
		if msaa_list[i].abbr == GlobalOptions.current_msaa:
			option_button_node.select(i)


func update_msaa_list():
	msaa_list.clear()
	
	msaa_list = [
		{
			abbr = Viewport.MSAA_DISABLED,
			locale = tr("DISABLED"),
		}, 
		{
			abbr = Viewport.MSAA_2X,
			locale = "x2",
		}, 
		{
			abbr = Viewport.MSAA_4X,
			locale = "x4",
		}, 
		{
			abbr = Viewport.MSAA_8X,
			locale = "x8",
		}, 
		{
			abbr = Viewport.MSAA_16X,
			locale = "x16",
		}, 
	]
