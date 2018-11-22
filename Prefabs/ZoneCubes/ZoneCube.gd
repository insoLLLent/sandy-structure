extends Spatial


var game_zone_node = null

var cubes = {}

var current_type = GlobalZoneCube.EMPTY
var current_node = null

var can_visible = false

# neighbors #
var top_cube = null
var bottom_cube = null
#############


func _enter_tree():
	game_zone_node = $"/root/Game/GameZone"
	
	for key in GlobalZoneCube.cubes.keys():
		if key == GlobalZoneCube.EMPTY:
			cubes[key] = GlobalZoneCube.cubes[key]
		else:
			cubes[key] = GlobalZoneCube.cubes[key].instance()


func _process(delta):
	if visible:
		if not can_visible:
			update_view()
			can_visible = true
	else:
		if can_visible:
			_free_current_node()
			current_type = GlobalZoneCube.EMPTY
			can_visible = false


func _exit_tree():
	for key in cubes.keys():
		if cubes[key] == null:
			continue
		
		cubes[key].queue_free()
	
	cubes.clear()


# обновить вид куба в зависимости от его положения и от соседних кубов
func update_view():
	_update_neighbors()
	_update_current_node()


func _update_neighbors():
	var x = round(translation.x)
	var y = round(translation.y)
	var z = round(translation.z)
	# собрать соседние кубы
	if round(y+1) < GlobalData.MAX_Y_CUBES:
		top_cube = game_zone_node.current_zone[x][round(y+1)][z]
		
		if not top_cube.visible:
			top_cube = null
	
	if round(y-1) >= 0:
		bottom_cube = game_zone_node.current_zone[x][round(y-1)][z]
		
		if not bottom_cube.visible:
			bottom_cube = null


# на основе информации о соседних кубах предложить 
# внешний вид текущего куба
func _update_current_node():
	if _update_current_type() == true:
		_free_current_node()
		
		if current_type != GlobalZoneCube.EMPTY:
			current_node = cubes[current_type]
			add_child(current_node)


# Обновить текущий тип куба.
# Если новый вид совпадает с предыдущим, то функция вернет false -
# это значит, что обновлять текущий куб не надо
func _update_current_type():
	var new_current_type = GlobalZoneCube.EMPTY
	
	if top_cube == null:
		if bottom_cube == null:
			new_current_type = GlobalZoneCube.SINGLE
		else:
			new_current_type = GlobalZoneCube.SINGLECOLUMN_FRONT_TOP
	else:
		if bottom_cube == null:
			new_current_type = GlobalZoneCube.SINGLECOLUMN_FRONT_BOTTOM
		else:
			new_current_type = GlobalZoneCube.SINGLECOLUMN_FRONT_CENTER
	
	if current_type == new_current_type:
		return false
	else:
		current_type = new_current_type
		return true


func _free_current_node():
	if GlobalFunctions.exists_node(current_node):
		#if current_node != null and current_node.has_method("queue_free"):
			#current_node.queue_free()
		if current_node != null:
			remove_child(current_node)
			current_node = null


