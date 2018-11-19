extends Node

signal game_over_sig
signal update_score_sig(current_score)
signal update_location

# списки фигур
var CubeNodes = [
	preload("res://Prefabs/Figures/Penta_01.tscn"),
	preload("res://Prefabs/Figures/Penta_02.tscn"),
	preload("res://Prefabs/Figures/Penta_03.tscn"),
	preload("res://Prefabs/Figures/Penta_04.tscn"),
	preload("res://Prefabs/Figures/Penta_05.tscn"),
	preload("res://Prefabs/Figures/Penta_06.tscn"),
	preload("res://Prefabs/Figures/Penta_07.tscn"),
	preload("res://Prefabs/Figures/Penta_08.tscn"),
	preload("res://Prefabs/Figures/Penta_09.tscn"),
	preload("res://Prefabs/Figures/Penta_10.tscn"),
	preload("res://Prefabs/Figures/Penta_11.tscn"),
	preload("res://Prefabs/Figures/Penta_12.tscn"),
]


# Текущий номер куба по списку
var current_cube_number = null

# текущий счет игрока
var current_score = 0

# текущий нод куба
var current_cube = null
# путь до текущего нода куба
var current_cube_path = ""

# все варианты визаулизации
var CubePoses = []
# индекс текущей визаулизации
var current_pose = 0

# список всех кубов-заполнителей текущей визуализации фигуры
var fillers = []
# список нижних кубов-заполнителей текущей визуализации фигуры
var bottom_fillers = []

# игровай зона, в которой происходит заполнение
var game_zone = null
# зона подсветки
var fall_zone = null
# нод таймера, отвечающего за падение фигуры
var timer_fall_node = null
# нод камеры игрока
var camera_node = null
# меню паузы
var pause_menu_node = null
# экран окончания игры
var dead_end_screen_node = null

# можно ли играть
var can_playing = true


func _ready():
	if not is_connected("update_location", GlobalZoneCube, "load_cube_view"):
		connect("update_location", GlobalZoneCube, "load_cube_view")
	
	GlobalOptions.settings_shadow_enabled()
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	game_zone = $GameZone
	fall_zone = $FallZone
	camera_node = $CameraPlayer
	pause_menu_node = $GUI/PauseMenu
	dead_end_screen_node = $GUI/DeadEndScreen
	timer_fall_node = $TimerFall
	timer_fall_node.wait_time = GlobalData.current_speed_fall
	
	if GlobalData.current_game_mode == GlobalData.GameMode.SAVE:
		init_load_data()
	
	emit_signal("update_location")
	emit_signal("update_score_sig", current_score)


##################
func is_valid_data(data):
	if data != null and \
	   typeof(data) == TYPE_DICTIONARY and \
	   data.has_all(["game", "camera_player", "game_zone"]) and \
	   typeof(data["game"]) == TYPE_DICTIONARY and \
	   typeof(data["camera_player"]) == TYPE_DICTIONARY and \
	   typeof(data["game_zone"]) == TYPE_DICTIONARY and \
	   data["game_zone"].has("visible") and \
	   typeof(data["camera_player"]) == TYPE_DICTIONARY and \
	   data["camera_player"].has_all(["view_direction", "translation", "rotation_degrees", "current_distance", "target_distance", "total_yaw", "total_pitch"]) and \
	   data["game"].has_all(["location", "current_score", "cube"]) and \
	   typeof(data["game"]["cube"]) == TYPE_DICTIONARY and \
	   data["game"]["cube"].has_all(["cube_number", "translation", "rotation_degrees", "pose"]):
		
		return true
	
	return false


func get_save_data():
	var data = {
		"game": {
			"location": GlobalData.current_location,
			"current_score": int(current_score),
			"cube": {
				"cube_number": int(current_cube_number),
				"translation": current_cube.translation,
				"rotation_degrees": current_cube.rotation_degrees,
				"pose": int(current_pose),
			},
		},
		"camera_player": {
			"view_direction": camera_node.current_view_direction,
			"translation": camera_node.translation,
			"rotation_degrees": camera_node.rotation_degrees,
			"current_distance": camera_node.current_distance,
			"target_distance": camera_node.target_distance,
			"total_yaw": camera_node.total_yaw,
			"total_pitch": camera_node.total_pitch,
		},
		"game_zone": {
			"visible": game_zone.get_list_all_visualised_blocks(),
		}
	}
	
	return data


func init_load_data():
	var data = GlobalSave.game_load_data()
	
	if not is_valid_data(data):
		return
	
	GlobalData.current_location = data.game.location
	
	current_score = int(data.game.current_score)
	game_zone.set_visible_blocks_by_array(data.game_zone.visible)
	
	camera_node.current_view_direction = data.camera_player.view_direction
	camera_node.translation = data.camera_player.translation
	camera_node.rotation_degrees = data.camera_player.rotation_degrees
	camera_node.current_distance = data.camera_player.current_distance
	camera_node.target_distance = data.camera_player.target_distance
	camera_node.total_yaw = data.camera_player.total_yaw
	camera_node.total_pitch = data.camera_player.total_pitch
	
	instance_cube(data.game.cube.cube_number, data.game.cube.translation, \
	              data.game.cube.rotation_degrees, data.game.cube.pose)

##################

# действия при отсчете таймера
func _on_TimerFall_timeout():
	cube_fall()


func _process(delta):
	if not can_playing or game_zone.is_check_filled:
		return
	
	if game_zone.is_game_over():
		game_over()
	else:
		pause_controller()
		
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		if current_cube_is_exists():
			if timer_fall_node.wait_time != GlobalData.current_speed_fall:
				timer_fall_node.wait_time = GlobalData.current_speed_fall
			
			position_controller()
			y_rotation_controller()
			pose_change_controller()
			fall_controller()
		else:
			zone_cube_update()
			instance_cube()


func zone_cube_update():
	for x in range(GlobalData.MAX_X_CUBES):
		for y in range(GlobalData.MAX_Y_CUBES):
			for z in range(GlobalData.MAX_Z_CUBES):
				if game_zone.current_zone[x][y][z].visible:
					#game_zone.current_zone[x][y][z].call_deferred("update_view")
					game_zone.current_zone[x][y][z].update_view()


func current_cube_is_exists():
	return (current_cube_path != "") and has_node(current_cube_path)


# создание куба
func instance_cube(load_cube_number = null, load_translation = null, load_rotation_degrees = null, load_pose = null):
	GlobalData.current_speed_fall = GlobalData.SPEED_FALL_NORMAL
	
	if load_cube_number == null:
		randomize()
		current_cube_number = randi() % CubeNodes.size()
	else:
		current_cube_number = load_cube_number
	
	
	current_cube = CubeNodes[current_cube_number].instance()
	add_child(current_cube)
	
	if load_translation == null:
		current_cube.translation = GlobalData.SPAWN_COORD
	else:
		current_cube.translation = load_translation
	
	current_cube_path = current_cube.get_path()
	
	init_cube_pose(load_pose)
	
	if load_rotation_degrees == null:
		random_cube_rotation_y()
	else:
		current_cube.rotation_degrees = load_rotation_degrees
	
	init_fillers()
	
	timer_fall_node.start()


# инициализация куба
func init_cube_pose(load_pose = null):
	CubePoses.clear()
	# получить дочерние объекты Filler_Cube
	CubePoses = current_cube.get_node("Poses").get_children()
	
	# выбрать индекс случайного объекта для визуализации
	if load_pose == null:
		randomize()
		current_pose = randi() % CubePoses.size()
	else:
		current_pose = load_pose
		
		if (current_pose+1) > CubePoses.size():
			current_pose = 0
	
	visualize_current_pose()


# повернуть фигуру в случайную сторону
func random_cube_rotation_y():
	if not current_cube.can_rotation:
		return
	
	current_cube.rotation_degrees.y = \
	            GlobalData.STEP_ROTATION * round(rand_range(0, 3))
	
	normalize_rotation_y_current_cube()


func init_fillers():
	fillers.clear()
	
	# заполнить массив для всех кубов и для нижних кубов
	for filler in CubePoses[current_pose].get_children():
		fillers.append(filler)
	
	init_bottom_fillers()


func init_bottom_fillers():
	bottom_fillers.clear()
	
	bottom_fillers.append(fillers[0])
	
	var app = true
	for i in range(1, fillers.size()):
		for j in range(bottom_fillers.size()):
			if (round(fillers[i].global_transform.origin.x) == round(bottom_fillers[j].global_transform.origin.x)) and \
			   (round(fillers[i].global_transform.origin.z) == round(bottom_fillers[j].global_transform.origin.z)):
				
				if round(fillers[i].global_transform.origin.y) < round(bottom_fillers[j].global_transform.origin.y):
					bottom_fillers[j] = fillers[i]
				
				app = false
				break
		
		if app:
			bottom_fillers.append(fillers[i])
		else:
			app = true


# есть ли хотя бы под одним нижним кубом визуализированный куб
func _is_bottom_filler():
	for filler in fillers:
		var under_filler = game_zone.current_zone[round(filler.global_transform.origin.x)]\
		                                         [round(filler.global_transform.origin.y - 1)]\
		                                         [round(filler.global_transform.origin.z)]
		
		if under_filler.visible:
			return true
		
	return false


# визуализировать кубы
func show_GameZone_filler():
	for filler in fillers:
		var need_show_cube = game_zone.current_zone[round(filler.global_transform.origin.x)]\
		                                           [round(filler.global_transform.origin.y)]\
		                                           [round(filler.global_transform.origin.z)]
		need_show_cube.show()


# находятся ли кубы-заполнители внутри игровой зоны
func fillers_in_zone():
	for filler in fillers:
		var x = round(filler.global_transform.origin.x)
		var z = round(filler.global_transform.origin.z)
		
		if x < 0 or z < 0 or \
		   x >= GlobalData.MAX_X_CUBES or \
		   z >= GlobalData.MAX_Z_CUBES:
			return false
		
	return true


# находятся ли кубы-заполнители внутри визуализированных кубов
func fillers_in_visible_cube():
	for filler in fillers:
		var cube = game_zone.current_zone[round(filler.global_transform.origin.x)]\
		                                 [round(filler.global_transform.origin.y)]\
		                                 [round(filler.global_transform.origin.z)]
		
		if cube.visible:
			return true
	
	return false


# нормализация поворота по Y, 
# чтобы значение не выходило за заданный диапазон
func normalize_rotation_y_current_cube():
	current_cube.rotation_degrees.y = \
	                wrapi(current_cube.rotation_degrees.y, 0, 360)


# следующая поза фигуры
func next_pose(var offset = 1):
	change_pose(offset)

# предыдущая поза фигуры
func prev_pose(var offset = 1):
	change_pose(-offset)

# изменить позу фигуры
func change_pose(var offset):
	current_pose = wrapi(current_pose + offset, 0, CubePoses.size())
	visualize_current_pose()
	init_fillers()


# визуализировать текущую позу фигуры
func visualize_current_pose():
	if (CubePoses == null) or CubePoses.empty():
		return
	
	# скрыть все дочерние объекты
	for item in CubePoses:
		if item != null:
			item.hide()
	
	# визуализировать текущий объект
	if CubePoses[current_pose] != null:
		CubePoses[current_pose].show()


# действия при завершении игры
func game_over():
	if current_cube_is_exists():
		current_cube.queue_free()
		current_cube = null
		current_cube_path = ""
		current_cube_number = null
		fillers.clear()
		bottom_fillers.clear()
		fillers = []
		bottom_fillers = []
	
	timer_fall_node.stop()
	GlobalData.current_speed_fall = GlobalData.SPEED_FALL_NORMAL
	can_playing = false
	emit_signal("game_over_sig")
	GlobalSave.game_save_remove()
	
	GlobalTop10.settings_top10(current_score)
	can_playing = false
	dead_end_screen_node.show_dead_end()


### управление кубом ###
#

# Падение куба
func cube_fall():
	if (current_cube.translation.y > 0 and _is_bottom_filler()) \
	   or current_cube.translation.y <= 0:
		# фигура коснулась поверхности
		show_GameZone_filler()
		timer_fall_node.stop()
		current_cube.queue_free()
		current_cube = null
		current_cube_path = ""
		current_cube_number = null
		fillers.clear()
		bottom_fillers.clear()
		fillers = []
		bottom_fillers = []
		GlobalData.current_speed_fall = GlobalData.SPEED_FALL_NORMAL
		game_zone.is_check_filled = true
	else:
		current_cube.translation.y -= GlobalData.STEP_MOVE


# изменение позиции
func position_controller():
	if not current_cube_is_exists():
		return
	
	var prev_translation_x = current_cube.translation.x
	var prev_translation_z = current_cube.translation.z
	
	match camera_node.current_view_direction:
		camera_node.CAMERA_FRONT:
			if Input.is_action_just_pressed("game_up"):
				current_cube.translation.z -= GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_down"):
				current_cube.translation.z += GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_left"):
				current_cube.translation.x -= GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_right"):
				current_cube.translation.x += GlobalData.STEP_MOVE
		camera_node.CAMERA_LEFT:
			if Input.is_action_just_pressed("game_up"):
				current_cube.translation.x += GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_down"):
				current_cube.translation.x -= GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_left"):
				current_cube.translation.z -= GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_right"):
				current_cube.translation.z += GlobalData.STEP_MOVE
		camera_node.CAMERA_RIGHT:
			if Input.is_action_just_pressed("game_up"):
				current_cube.translation.x -= GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_down"):
				current_cube.translation.x += GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_left"):
				current_cube.translation.z += GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_right"):
				current_cube.translation.z -= GlobalData.STEP_MOVE
		camera_node.CAMERA_BACK:
			if Input.is_action_just_pressed("game_up"):
				current_cube.translation.z += GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_down"):
				current_cube.translation.z -= GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_left"):
				current_cube.translation.x += GlobalData.STEP_MOVE
			if Input.is_action_just_pressed("game_right"):
				current_cube.translation.x -= GlobalData.STEP_MOVE
	
	if not fillers_in_zone() or fillers_in_visible_cube():
		current_cube.translation.x = prev_translation_x
		current_cube.translation.z = prev_translation_z
	else:
		show_FallZone_by_fillers()


# поворот по оси y
func y_rotation_controller():
	if not current_cube_is_exists() or not current_cube.can_rotation:
		return
	
	var prev_rot_y = current_cube.rotation_degrees.y
	
	if Input.is_action_just_pressed("game_rot_y_left"):
		current_cube.rotation_degrees.y -= GlobalData.STEP_ROTATION
		normalize_rotation_y_current_cube()
	if Input.is_action_just_pressed("game_rot_y_right"):
		current_cube.rotation_degrees.y += GlobalData.STEP_ROTATION
		normalize_rotation_y_current_cube()
	
	if not fillers_in_zone() or fillers_in_visible_cube():
		current_cube.rotation_degrees.y = prev_rot_y
	else:
		show_FallZone_by_fillers()

# изменение позы нода
func pose_change_controller():
	if (CubePoses != null) and (CubePoses.size() < 2):
		return
	
	if Input.is_action_just_pressed("game_change_pose_next"):
		next_pose()
		if not fillers_in_zone() or fillers_in_visible_cube():
			prev_pose()
		else:
			show_FallZone_by_fillers()
	if Input.is_action_just_pressed("game_change_pose_prev"):
		prev_pose()
		if not fillers_in_zone() or fillers_in_visible_cube():
			next_pose()
		else:
			show_FallZone_by_fillers()
	


# изменение скорости падения куба
func fall_controller():
	if not current_cube_is_exists():
		return
	
	if Input.is_action_just_pressed("game_fall"):
		if current_cube.translation.y > 0:
			cube_fall()
			show_FallZone_by_fillers()
	elif Input.is_action_pressed("game_fall"):
		GlobalData.current_speed_fall = GlobalData.SPEED_FALL_FORCE
		show_FallZone_by_fillers()
	elif Input.is_action_just_released("game_fall"):
		GlobalData.current_speed_fall = GlobalData.SPEED_FALL_NORMAL
		show_FallZone_by_fillers()
	elif not Input.is_action_pressed("game_fall"): # важное уточнение; на случай, если игрок выходит из паузы
		GlobalData.current_speed_fall = GlobalData.SPEED_FALL_NORMAL
		show_FallZone_by_fillers()


# пауза
func pause_controller():
	if Input.is_action_just_pressed("game_pause") or Input.is_action_just_pressed("main_menu_back"):
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

#
#########################


# Показать кубы заполнители, отображающие места падения фигуры
func show_FallZone_by_fillers():
	var top_coords = []
	
	# получить список ближайших визуализированных кубов
	for filler in bottom_fillers:
		var coord = game_zone.get_top_position_relatively(filler.global_transform.origin)
		if coord == null:
			#coord = Vector3(filler.global_transform.origin.x, -1, filler.global_transform.origin.z)
			coord = filler.global_transform.origin
			coord.y = -1
		top_coords.append([filler, coord])
	
	if top_coords.empty():
		fall_zone.hide_current_visualise()
		return
	
	
	# получить из списка координату с максимальным игреком
	var fac = round(top_coords[0][0].global_transform.origin.y - top_coords[0][1].y) - 1
	for i in range(1, top_coords.size()):
		var tmp_fac = round(top_coords[i][0].global_transform.origin.y - top_coords[i][1].y) - 1
		if tmp_fac < fac:
			fac = tmp_fac
	
	
	# не отображать подсветку если фигура приблизилась к ней на max_filler_y_for_fac
	var max_filler_y_for_fac = 0
	for filler in fillers:
		var rnd_y = round(filler.translation.y)
		if rnd_y > max_filler_y_for_fac:
			max_filler_y_for_fac = rnd_y
		
	if fac <= max_filler_y_for_fac:
		fall_zone.hide_current_visualise()
		return
	
	
	# создать список координат, по которым надо визуализировать
	# кубы заполнители места падения
	var fall_coords = []
	for filler in fillers:
		var new_coord = filler.global_transform.origin
		new_coord.y -= fac
		fall_coords.append(new_coord)
	
	if fall_coords.empty():
		fall_zone.hide_current_visualise()
		return
	
	
	fall_zone.hide_current_visualise()
	fall_zone.new_current_visualise(fall_coords)
	fall_zone.show_current_visualise()
	

# увеличить счет
func _on_GameZone_update_score_sig(score, bonus):
	current_score += round(GlobalData.SCORE_FACTOR * score * bonus)
	emit_signal("update_score_sig", current_score)

