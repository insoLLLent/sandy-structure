extends Node

var current_top10 = []

var has_changed = true

func _ready():
	set_process(false)
	
	for i in range(10):
		current_top10.append(0)
	
	if GlobalSave.top10_save_is_exists():
		init_load_data()
	else:
		# если файл опций не существует, то создать новый с настройками по-умолчанию
		GlobalSave.top10_save_data(get_save_data())
	
	init_settings()


func _process(delta):
	if has_changed:
		init_settings()
		has_changed = false
		set_process(false)


##################
func is_valid_data(data):
	if (data != null) and (typeof(data) == TYPE_ARRAY):
		return true
	
	return false

# собрать текущие настройки и вернуть в виде словаря
func get_save_data():
	var data = current_top10.duplicate()
	
	return data


func init_load_data():
	var data = GlobalSave.top10_load_data()
	
	if not is_valid_data(data):
		return
	
	current_top10 = data
##################


func init_settings():
	settings_top10()


# если переданный параметр не null, то пересохранить файл настроек
func save_if_param_not_null(param):
	if param != null:
		GlobalSave.top10_save_data(get_save_data())


func settings_top10(top10 = null):
	if top10 != null:
		current_top10.append(top10)
	
	current_top10.sort()
	current_top10.invert()
	
	if current_top10.size() != 10:
		current_top10.resize(10)
	
	for i in range(current_top10.size()):
		if current_top10[i] == null:
			current_top10[i] = 0
	
	current_top10.sort()
	current_top10.invert()
	
	save_if_param_not_null(top10)
	
	has_changed = true
	set_process(true)

