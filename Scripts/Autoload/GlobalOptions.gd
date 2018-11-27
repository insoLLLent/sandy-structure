extends Node


"""
Синглтон; хранилище и инициализация настроек игры.
"""


# список environments, на которые распространяется настройка ssao
var list_environments_for_options = [
	preload("res://Environment/MainMenuCameraEnvironment.tres"),
	preload("res://Environment/CameraPlayerEnvironmentLite.tres"),
	preload("res://Environment/CameraPlayerEnvironmentDunes.tres"),
]


# Значения настроек по-умолчанию
# Video
var current_quality = GlobalData.QualitySettings.MEDIUM
var current_screen_size = GlobalData.SCREEN_SIZES[GlobalData.SCREEN_SIZE_AUTO]
var current_language = GlobalData.L18N_AUTO
var current_vsync = true
var current_fps = GlobalData.FPS_DEFAULT
var current_msaa = Viewport.MSAA_8X
var current_ssao = GlobalData.EnvironmentSSAO.DISABLED
var current_shadow_enabled = true

# controls
var current_mouse_sensitivity = 1.1

var current_key_up = null
var current_key_down = null
var current_key_left = null
var current_key_right = null
var current_key_fall = null
var current_key_rot_y_left = null
var current_key_rot_y_right = null
var current_key_change_pose_prev = null
var current_key_change_pose_next = null
var current_key_pause = null


var has_changed = true

func _ready():
	init_default_control_keys()
	
	if GlobalSave.options_save_is_exists():
		set_settings_by_options_file()
	else:
		# если файл опций не существует, то создать новый с настройками по-умолчанию
		GlobalSave.options_save_data(get_save_data())
	
	init_settings()


func _process(delta):
	if has_changed:
		init_settings()
		has_changed = false


##################
func is_valid_data(data):
	if data != null and \
	   typeof(data) == TYPE_DICTIONARY and \
	   data.has_all(["language", "options"]) and \
	   typeof(data["options"]) == TYPE_DICTIONARY and \
	   data["options"].has_all(["video", "music", "controls"]) and \
	   typeof(data["options"]["video"]) == TYPE_DICTIONARY and \
	   typeof(data["options"]["music"]) == TYPE_DICTIONARY and \
	   typeof(data["options"]["controls"]) == TYPE_DICTIONARY and \
	   data["options"]["video"].has_all(["quality", "screen_size", "vsync", "fps", "msaa", "ssao", "shadow_enabled"]) and \
	   data["options"]["controls"].has_all(["mouse_sensitivity", "control_keys"]) and \
	   typeof(data["options"]["controls"]["control_keys"]) == TYPE_DICTIONARY and \
	   data["options"]["controls"]["control_keys"].has_all(["up", "down", "left", "right", "fall", "rot_y_left", "rot_y_right", "change_pose_prev", "change_pose_next", "pause"]):
		
		return true
	
	return false

# собрать текущие настройки и вернуть в виде словаря
func get_save_data():
	var data = {
		"language": current_language,
		"options": {
			"video": {
				"quality": current_quality,
				"screen_size": current_screen_size,
				"vsync": current_vsync,
				"fps": current_fps,
				"msaa": current_msaa,
				"ssao": current_ssao,
				"shadow_enabled": current_shadow_enabled,
			},
			"music": {
				
			},
			"controls": {
				"mouse_sensitivity": current_mouse_sensitivity,
				"control_keys": {
					"up": current_key_up,
					"down": current_key_down,
					"left": current_key_left,
					"right": current_key_right,
					"fall": current_key_fall,
					"rot_y_left": current_key_rot_y_left,
					"rot_y_right": current_key_rot_y_right,
					"change_pose_prev": current_key_change_pose_prev,
					"change_pose_next": current_key_change_pose_next,
					"pause": current_key_pause,
				},
			},
		},
	}
	
	return data


func set_settings_by_options_file():
	var data = GlobalSave.options_load_data()
	
	if not is_valid_data(data):
		return
	
	#video
	current_quality = data.options.video.quality
	current_language = data.language
	current_screen_size = data.options.video.screen_size
	current_vsync = data.options.video.vsync
	current_fps = data.options.video.fps
	current_msaa = data.options.video.msaa
	current_ssao = data.options.video.ssao
	current_shadow_enabled = data.options.video.shadow_enabled
	
	
	#controls
	current_mouse_sensitivity = data.options.controls.mouse_sensitivity
	
	current_key_up = data.options.controls.control_keys.up
	current_key_down = data.options.controls.control_keys.down
	current_key_left = data.options.controls.control_keys.left
	current_key_right = data.options.controls.control_keys.right
	current_key_fall = data.options.controls.control_keys.fall
	current_key_rot_y_left = data.options.controls.control_keys.rot_y_left
	current_key_rot_y_right = data.options.controls.control_keys.rot_y_right
	current_key_change_pose_prev = data.options.controls.control_keys.change_pose_prev
	current_key_change_pose_next = data.options.controls.control_keys.change_pose_next
	current_key_pause = data.options.controls.control_keys.pause
##################

var ACTION_NAME_LIST = [
	"game_up", "game_down", "game_left", "game_right",
	"game_fall", "game_rot_y_left", "game_rot_y_right",
	"game_change_pose_prev", "game_change_pose_next",
	"game_pause"
]

func init_default_control_keys():
	current_key_up = get_scancode_string_by_action_name("game_up")
	current_key_down = get_scancode_string_by_action_name("game_down")
	current_key_left = get_scancode_string_by_action_name("game_left")
	current_key_right = get_scancode_string_by_action_name("game_right")
	current_key_fall = get_scancode_string_by_action_name("game_fall")
	current_key_rot_y_left = get_scancode_string_by_action_name("game_rot_y_left")
	current_key_rot_y_right = get_scancode_string_by_action_name("game_rot_y_right")
	current_key_change_pose_prev = get_scancode_string_by_action_name("game_change_pose_prev")
	current_key_change_pose_next = get_scancode_string_by_action_name("game_change_pose_next")
	current_key_pause = get_scancode_string_by_action_name("game_pause")

func get_scancode_string_by_action_name(action_name):
	var action_list = InputMap.get_action_list(action_name)
	return OS.get_scancode_string(action_list[0].scancode)

func change_control_key(action_name, new_key):
	if new_key == get_scancode_string_by_action_name(action_name):
		return
	
	var new_event = InputEventKey.new()
	new_event.scancode = OS.find_scancode_from_string(new_key)
	
	for old_event in InputMap.get_action_list(action_name):
		if old_event is InputEventKey:
			InputMap.action_erase_event(action_name, old_event)
	
	InputMap.action_add_event(action_name, new_event)

func has_control_key(str_scancode, exclude_action):
	for action_name in ACTION_NAME_LIST:
		if action_name == exclude_action:
			continue
		
		for event in InputMap.get_action_list(action_name):
			if event is InputEventKey:
				if str_scancode == OS.get_scancode_string(event.scancode):
					return true
	
	return false



func init_settings():
	init_video_settings()
	init_music_settings()
	init_controls_settings()


func init_video_settings():
	settings_quality()
	settings_screen_size()
	settings_language()
	settings_vsync()
	settings_fps()
	settings_msaa()
	settings_ssao()
	settings_shadow_enabled()


func init_music_settings():
	pass


func init_controls_settings():
	settings_mouse_sensitivity()
	settings_key_up()
	settings_key_down()
	settings_key_left()
	settings_key_right()
	settings_key_fall()
	settings_key_rot_y_left()
	settings_key_rot_y_right()
	settings_key_change_pose_prev()
	settings_key_change_pose_next()
	settings_key_pause()


# если переданный параметр не null, то пересохранить файл настроек
func save_if_param_not_null(param):
	if param != null:
		GlobalSave.options_save_data(get_save_data())


func settings_language(lang = null):
	if lang != null:
		current_language = lang
	
	has_changed = true
	
	# Автоматически подобрать язык игры
	if current_language == GlobalData.L18N_AUTO:
		current_language = OS.get_locale()
	
	if not (current_language in [GlobalData.L18N_EN, GlobalData.L18N_RU]):
		current_language = GlobalData.L18N_EN
	
	TranslationServer.set_locale(current_language)
	
	save_if_param_not_null(lang)


########### quality ###########
func settings_quality(quality = null):
	if quality != null:
		current_quality = quality
	
	has_changed = true
	
	match current_quality:
		GlobalData.QualitySettings.LOW:
			set_quality_low()
		GlobalData.QualitySettings.MEDIUM:
			set_quality_medium()
		GlobalData.QualitySettings.HIGH:
			set_quality_high()
	
	save_if_param_not_null(quality)

func set_quality_low():
	settings_vsync(false)
	settings_msaa(Viewport.MSAA_2X)
	settings_ssao(GlobalData.EnvironmentSSAO.DISABLED)
	settings_shadow_enabled(false)

func set_quality_medium():
	settings_vsync(true)
	settings_msaa(Viewport.MSAA_8X)
	settings_ssao(GlobalData.EnvironmentSSAO.DISABLED)
	settings_shadow_enabled(true)

func set_quality_high():
	settings_vsync(true)
	settings_msaa(Viewport.MSAA_16X)
	settings_ssao(GlobalData.EnvironmentSSAO.LOW)
	settings_shadow_enabled(true)

###############################

func settings_screen_size(screen_size = null):
	if screen_size != null:
		current_screen_size = screen_size
	
	has_changed = true
	
	# Автоматически подобрать размер экрана
	if current_screen_size == GlobalData.SCREEN_SIZES[GlobalData.SCREEN_SIZE_AUTO]:
		current_screen_size = OS.get_screen_size(OS.current_screen)
	
	
	get_tree().get_root().size = current_screen_size
	OS.window_size = current_screen_size
	
	save_if_param_not_null(screen_size)


func settings_vsync(vsync = null):
	if vsync != null:
		current_vsync = vsync
	
	has_changed = true
	
	OS.vsync_enabled = current_vsync
	
	save_if_param_not_null(vsync)
	
	if current_fps > GlobalData.FPS_60:
		settings_fps(GlobalData.FPS_60)


func settings_fps(fps = null):
	if fps != null:
		current_fps = fps
	
	if current_vsync and current_fps > GlobalData.FPS_60:
		current_fps = GlobalData.FPS_60
	
	has_changed = true
	
	Engine.target_fps = current_fps
	
	save_if_param_not_null(fps)


func settings_msaa(msaa = null):
	if msaa != null:
		current_msaa = msaa
	
	has_changed = true
	
	get_tree().get_root().msaa = current_msaa
	
	save_if_param_not_null(msaa)


func settings_ssao(ssao = null):
	if ssao != null:
		current_ssao = ssao
	
	has_changed = true
	
	for env in list_environments_for_options:
		if current_ssao == GlobalData.EnvironmentSSAO.DISABLED:
			env.ssao_enabled = false
		else:
			env.ssao_enabled = true
			env.ssao_quality = current_ssao
	
	save_if_param_not_null(ssao)


func settings_shadow_enabled(shadow_enabled = null):
	if shadow_enabled != null:
		current_shadow_enabled = shadow_enabled
	
	
	for n in get_tree().get_nodes_in_group(GlobalData.GROUP_ILLUMINANT):
		n.shadow_enabled = current_shadow_enabled
	
	
	save_if_param_not_null(shadow_enabled)



func settings_mouse_sensitivity(mouse_sensitivity = null):
	if mouse_sensitivity != null:
		current_mouse_sensitivity = mouse_sensitivity
	
	has_changed = true
	
	# Здесь ничего не происходит, т.к. current_mouse_sensitivity
	# используется в другом скрипте.
	
	save_if_param_not_null(mouse_sensitivity)


func settings_key_up(new_key = null):
	var action_name = "game_up"
	
	if new_key == null:
		if has_control_key(current_key_up, action_name):
			return
	else:
		if has_control_key(new_key, action_name):
			return
		else:
			current_key_up = new_key
	
	change_control_key(action_name, current_key_up)
	
	save_if_param_not_null(new_key)


func settings_key_down(new_key = null):
	var action_name = "game_down"
	
	if new_key == null:
		if has_control_key(current_key_down, action_name):
			return
	else:
		if has_control_key(new_key, action_name):
			return
		else:
			current_key_down = new_key
	
	change_control_key(action_name, current_key_down)
	
	save_if_param_not_null(new_key)


func settings_key_left(new_key = null):
	var action_name = "game_left"
	
	if new_key == null:
		if has_control_key(current_key_left, action_name):
			return
	else:
		if has_control_key(new_key, action_name):
			return
		else:
			current_key_left = new_key
	
	change_control_key(action_name, current_key_left)
	
	save_if_param_not_null(new_key)


func settings_key_right(new_key = null):
	var action_name = "game_right"
	
	if new_key == null:
		if has_control_key(current_key_right, action_name):
			return
	else:
		if has_control_key(new_key, action_name):
			return
		else:
			current_key_right = new_key
	
	change_control_key(action_name, current_key_right)
	
	save_if_param_not_null(new_key)


func settings_key_fall(new_key = null):
	var action_name = "game_fall"
	
	if new_key == null:
		if has_control_key(current_key_fall, action_name):
			return
	else:
		if has_control_key(new_key, action_name):
			return
		else:
			current_key_fall = new_key
	
	change_control_key(action_name, current_key_fall)
	
	save_if_param_not_null(new_key)


func settings_key_rot_y_left(new_key = null):
	var action_name = "game_rot_y_left"
	
	if new_key == null:
		if has_control_key(current_key_rot_y_left, action_name):
			return
	else:
		if has_control_key(new_key, action_name):
			return
		else:
			current_key_rot_y_left = new_key
	
	change_control_key(action_name, current_key_rot_y_left)
	
	save_if_param_not_null(new_key)


func settings_key_rot_y_right(new_key = null):
	var action_name = "game_rot_y_right"
	
	if new_key == null:
		if has_control_key(current_key_rot_y_right, action_name):
			return
	else:
		if has_control_key(new_key, action_name):
			return
		else:
			current_key_rot_y_right = new_key
	
	change_control_key(action_name, current_key_rot_y_right)
	
	save_if_param_not_null(new_key)


func settings_key_change_pose_prev(new_key = null):
	var action_name = "game_change_pose_prev"
	
	if new_key == null:
		if has_control_key(current_key_change_pose_prev, action_name):
			return
	else:
		if has_control_key(new_key, action_name):
			return
		else:
			current_key_change_pose_prev = new_key
	
	change_control_key(action_name, current_key_change_pose_prev)
	
	save_if_param_not_null(new_key)


func settings_key_change_pose_next(new_key = null):
	var action_name = "game_change_pose_next"
	
	if new_key == null:
		if has_control_key(current_key_change_pose_next, action_name):
			return
	else:
		if has_control_key(new_key, action_name):
			return
		else:
			current_key_change_pose_next = new_key
	
	change_control_key(action_name, current_key_change_pose_next)
	
	save_if_param_not_null(new_key)


func settings_key_pause(new_key = null):
	var action_name = "game_pause"
	
	if new_key == null:
		if has_control_key(current_key_pause, action_name):
			return
	else:
		if has_control_key(new_key, action_name):
			return
		else:
			current_key_pause = new_key
	
	change_control_key(action_name, current_key_pause)
	
	save_if_param_not_null(new_key)


