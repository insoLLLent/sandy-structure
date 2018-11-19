extends Spatial


var game_zone_node = null

var current_type = GlobalZoneCube.EMPTY
var current_node = null

var can_visible = false

# neighbors #
var top_cube = null
var bottom_cube = null
#############


func _ready():
	game_zone_node = $".."
	visible = can_visible


func _process(delta):
	if visible:
		if not can_visible:
			update_view()
			can_visible = true
	else:
		if can_visible:
			_free_current_node()
			can_visible = false


# обновить вид куба в зависимости от его положения и от соседних кубов
func update_view():
	_free_current_node()
	_update_neighbors()
	_update_current_node()
	
	if current_type != GlobalZoneCube.EMPTY:
		add_child(current_node)



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
	_update_current_type()
	
	if current_type != GlobalZoneCube.EMPTY:
		current_node = GlobalZoneCube.cubes[current_type].instance()


func _free_current_node():
	if GlobalFunctions.exists_node(current_node):
		if current_node != null and current_node.has_method("queue_free"):
			current_node.queue_free()
			current_type = GlobalZoneCube.EMPTY
			current_node = null


func _update_current_type():
	if top_cube == null:
		if bottom_cube == null:
			current_type = GlobalZoneCube.SINGLE
		else:
			current_type = GlobalZoneCube.SINGLECOLUMN_FRONT_TOP
	else:
		if bottom_cube == null:
			current_type = GlobalZoneCube.SINGLECOLUMN_FRONT_BOTTOM
		else:
			current_type = GlobalZoneCube.SINGLECOLUMN_FRONT_CENTER

