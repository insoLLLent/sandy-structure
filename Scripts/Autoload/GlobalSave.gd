extends Node


"""
Синглтон; загрузка и сохранение данных.
"""

const CIPHER = "ffonafil"

var fh = File.new()
var dh = Directory.new()
var dir_save_path = "user://"

var game_save_name = "game.bin"
var game_save_path = dir_save_path + game_save_name

var options_save_name = "options.bin"
var options_save_path = dir_save_path + options_save_name

var top10_save_name = "table.bin"
var top10_save_path = dir_save_path + top10_save_name

func _ready():
	if not dh.dir_exists(dir_save_path):
		dh.make_dir_recursive(dir_save_path) # is OK?


###### GAME ######
func game_save_data(data):
	_save_data(game_save_path, data)

func game_load_data():
	return _load_data(game_save_path)

func game_save_is_exists():
	return _savefile_is_exists(game_save_path)

func game_save_remove():
	return _savefile_remove(game_save_path)
##################


##### OPTIONS #####
func options_save_data(data):
	_save_data(options_save_path, data)

func options_load_data():
	return _load_data(options_save_path)

func options_save_is_exists():
	return _savefile_is_exists(options_save_path)

func options_save_remove():
	return _savefile_remove(options_save_path)
###################


##### TABLE #####
func top10_save_data(data):
	_save_data(top10_save_path, data)

func top10_load_data():
	return _load_data(top10_save_path)

func top10_save_is_exists():
	return _savefile_is_exists(top10_save_path)

func top10_save_remove():
	return _savefile_remove(top10_save_path)
###################


##### GENERAL #####
func _save_data(filepath, data):
	#_savefile_remove(filepath)
	
	fh.open_encrypted_with_pass(filepath, File.WRITE, CIPHER)
	fh.store_var(data)
	fh.close()


func _load_data(filepath):
	if not _savefile_is_exists(filepath):
		return null
	
	var check_err = fh.open_encrypted_with_pass(filepath, File.READ, CIPHER)
	
	if check_err != OK:
		return null
		
	var save_data = fh.get_var()
	fh.close()
	
	return save_data


func _savefile_is_exists(filepath):
	if dh.file_exists(filepath):
		return true
	
	return false


func _savefile_remove(filepath):
	if _savefile_is_exists(filepath):
		if dh.remove(filepath) == OK:
			return true
	else:
		return true
	
	return false
###################
