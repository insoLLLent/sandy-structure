extends Spatial


signal update_score_sig(score, bonus)


var fillerCubePath = preload("res://Prefabs/ZoneCubes/ZoneCube.tscn")

# представление игровой зоны
var current_zone = []

# идет ли процесс проверки заполненных зон
var is_check_filled = false;

const MAX_TIMER_DESTROY = .2
var timer_destroy = 0

var score_bonus = 0

var block_destroing_sound_node = null

func _enter_tree():
	generate_zone()


func _ready():
	block_destroing_sound_node = $BlockDestroingSound


func _process(delta):
	if is_check_filled:
		if timer_destroy < MAX_TIMER_DESTROY:
			timer_destroy += delta
		else:
			if has_filled_line():
				score_bonus += GlobalData.BONUS_FACTOR
				destroy_filled_line()
				
				#if not block_destroing_sound_node.playing:
				block_destroing_sound_node.play()
				
			else:
				score_bonus = 0
				is_check_filled = false
			
			timer_destroy = 0



# заполнение игровой зоны невидимыми кубами 
func generate_zone():
	for x in range(GlobalData.MAX_X_CUBES):
		var xChild = Spatial.new()
		add_child(xChild)
		
		for y in range(GlobalData.MAX_Y_CUBES):
			var yChild = Spatial.new()
			xChild.add_child(yChild)
			current_zone.append([])
			
			for z in range(GlobalData.MAX_Z_CUBES):
				current_zone[x].append([])
				current_zone[x][y].append(fillerCubePath.instance())
				yChild.add_child(current_zone[x][y][z])
				current_zone[x][y][z].translation = Vector3(x, y, z)
				current_zone[x][y][z].hide()
				
				# показать блоки в случайных местах, 
				# чтобы при старте игры поле не было пустым
				randomize()
				if randi() % 2 == 1:
					if y > 0:
						randomize()
						if (randi() % 2 == 1) and current_zone[x][y-1][z].visible:
							current_zone[x][y][z].show()
					else:
						current_zone[x][y][z].show()
#					if y < 15:
#						current_zone[x][y][z].show()


# есть ли заполненные кубами линии
func has_filled_line():
	for y in range(GlobalData.MAX_Y_CUBES):
		
		for x in range(GlobalData.MAX_X_CUBES):
			var vis = true
			for z in range(GlobalData.MAX_Z_CUBES):
				if not current_zone[x][y][z].visible:
					vis = false
					break
			if vis:
				return true
		
		for z in range(GlobalData.MAX_Z_CUBES):
			var vis = true
			for x in range(GlobalData.MAX_X_CUBES):
				if not current_zone[x][y][z].visible:
					vis = false
					break
			if vis:
				return true
	
	return false


"""
# многопоточный вариант

var threads = []

# уничтожить заполненные линии
func destroy_filled_line():
	var need_destroy = get_destroing_lines()
	
	threads.clear()
	for i in range(need_destroy.size()):
		threads.append(Thread.new())
		threads[i].start(self, "destroy_by_Y_thread", need_destroy[i])
	
	for i in range(threads.size()):
		threads[i].wait_to_finish()
"""

# уничтожить заполненные линии
func destroy_filled_line():
	var need_destroy = get_destroing_lines()
	
	if not need_destroy or need_destroy.empty():
		return
	
	for i in need_destroy:
		for y in range(i.y, GlobalData.MAX_Y_CUBES - 1):
			current_zone[i.x][y][i.z].visible = current_zone[i.x][y+1][i.z].visible
	
	# сообщить об уничтожении линий
	var score_size = need_destroy.size()
	var extra_score = 0
	
	if score_size > GlobalData.MAX_X_CUBES:
		extra_score = (score_size - GlobalData.MAX_X_CUBES) * GlobalData.EXTRA_SCORE_FACTOR
	
	emit_signal("update_score_sig", score_size, score_bonus + extra_score)


# получить блоки, которые надо уничтожить
func get_destroing_lines():
	var need_destroy = []
	
	for y in range(GlobalData.MAX_Y_CUBES):
		
		for x in range(GlobalData.MAX_X_CUBES):
			if current_zone[x][y][0].visible:
				var vis = true
				for z in range(GlobalData.MAX_Z_CUBES):
					if not current_zone[x][y][z].visible:
						vis = false
						break
				if vis:
					for z in range(GlobalData.MAX_Z_CUBES):
						need_destroy.append(Vector3(x, y, z))
		
		for z in range(GlobalData.MAX_Z_CUBES):
			if current_zone[0][y][z].visible:
				var vis = true
				for x in range(GlobalData.MAX_X_CUBES):
					if not current_zone[x][y][z].visible:
						vis = false
						break
				if vis:
					for x in range(GlobalData.MAX_X_CUBES):
						need_destroy.append(Vector3(x, y, z))
		
		if need_destroy.size() != 0:
			break
	
	return unique_array(need_destroy)


# получить список уникальных элементов из переданного массива
func unique_array(arr):
	var uniq_arr = []
	
	for item in arr:
		if not uniq_arr.has(item):
			uniq_arr.append(item)
	
	return uniq_arr


# Визуализирована ли точка game over
func is_game_over():
	var y = GlobalData.GAME_OVER_BORDER
	
	for x in range(GlobalData.MAX_X_CUBES):
		for z in range(GlobalData.MAX_Z_CUBES):
			if current_zone[x][y][z].visible:
				return true
	
	return false


# возвращает список визуализированных и не визуализированных блоков
# в виде массива с булевым значением
func get_list_all_visualised_blocks():
	var vis_blocks = []
	
	for x in range(GlobalData.MAX_X_CUBES):
		for y in range(GlobalData.MAX_Y_CUBES):
			vis_blocks.append([])
			for z in range(GlobalData.MAX_Z_CUBES):
				vis_blocks[x].append([])
				vis_blocks[x][y].append(current_zone[x][y][z].visible)
	
	return vis_blocks


# Визуализировать блоки в соответствии с переданными в массиве данными
func set_visible_blocks_by_array(arr):
	for x in range(GlobalData.MAX_X_CUBES):
		for y in range(GlobalData.MAX_Y_CUBES):
			for z in range(GlobalData.MAX_Z_CUBES):
				current_zone[x][y][z].visible = arr[x][y][z]


# возвращает позицию самого верхнего визуализированного блока
func get_top_position():
	for y in range(GlobalData.MAX_Y_CUBES-1, -1, -1):
		for x in range(GlobalData.MAX_X_CUBES):
			for z in range(GlobalData.MAX_Z_CUBES):
				if current_zone[x][y][z].visible:
					return current_zone[x][y][z].translation
	
	return null

# возвращает позицию самого верхнего визуализированного блока
# оносительно переданных координат
func get_top_position_relatively(rel_pos):
	for y in range(round(rel_pos.y), -1, -1):
		var x = round(rel_pos.x)
		var z = round(rel_pos.z)
		
		if current_zone[x][y][z].visible:
			return current_zone[x][y][z].translation
	
	return null

