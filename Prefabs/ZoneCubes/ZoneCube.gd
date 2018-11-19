extends Spatial


var game_zone_node = null

var current_type = GlobalZoneCube.EMPTY
var current_node = null

var can_visible = false

# neighbors #
var top_cube = null
var bottom_cube = null
var left_cube = null
var right_cube = null
var front_cube = null
var back_cube = null
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
	
	if round(x+1) < GlobalData.MAX_X_CUBES:
		right_cube = game_zone_node.current_zone[round(x+1)][y][z]
		
		if not right_cube.visible:
			right_cube = null
	
	if round(x-1) >= 0:
		left_cube = game_zone_node.current_zone[round(x-1)][y][z]
		
		if not left_cube.visible:
			left_cube = null
	
	if round(z+1) < GlobalData.MAX_Z_CUBES:
		front_cube = game_zone_node.current_zone[x][y][round(z+1)]
		
		if not front_cube.visible:
			front_cube = null
	
	if round(z-1) >= 0:
		back_cube = game_zone_node.current_zone[x][y][round(x-1)]
		
		if not back_cube.visible:
			back_cube = null



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


"""func _update_current_type():
	if top_cube == null:
		if bottom_cube == null:
			if right_cube == null:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 000000
							current_type = GlobalZoneCube.SINGLE
						else:
							# 000001
							current_type = GlobalZoneCube.SINGLERECUMBENT_FRONT
					else:
						if back_cube == null:
							# 000010
							current_type = GlobalZoneCube.SINGLERECUMBENT_BACK
						else:
							# 000011
							current_type = GlobalZoneCube.SINGLERECUMBENT_CENTER
				else:
					if front_cube == null:
						if back_cube == null:
							# 000100
							current_type = GlobalZoneCube.SINGLERECUMBENTROT_RIGHT
						else:
							# 000101
							current_type = GlobalZoneCube.SINGLE_CENTER
					else:
						if back_cube == null:
							# 000110
							current_type = GlobalZoneCube.SINGLE_CENTER
						else:
							# 000111
							current_type = GlobalZoneCube.SINGLERECUMBENT_CENTER
			else:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 001000
							current_type = GlobalZoneCube.SINGLERECUMBENTROT_LEFT
						else:
							# 001001
							current_type = GlobalZoneCube.SINGLE_CENTER
					else:
						if back_cube == null:
							# 001010
							current_type = GlobalZoneCube.SINGLE_CENTER
						else:
							# 001011
							current_type = GlobalZoneCube.SINGLERECUMBENT_CENTER
				else:
					if front_cube == null:
						if back_cube == null:
							# 001100
							current_type = GlobalZoneCube.SINGLERECUMBENTROT_CENTER
						else:
							# 001101
							current_type = GlobalZoneCube.SINGLERECUMBENTROT_CENTER
					else:
						if back_cube == null:
							# 001110
							current_type = GlobalZoneCube.SINGLERECUMBENTROT_CENTER
						else:
							# 001111
							current_type = GlobalZoneCube.SINGLE_CENTER
							# or ->  current_type = GlobalZoneCube.SINGLERECUMBENT_CENTER
							# or ->  current_type = GlobalZoneCube.SINGLERECUMBENTROT_CENTER
		else:
			if right_cube == null:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 010000
							current_type = GlobalZoneCube.SINGLECOLUMN_FRONT_TOP
						else:
							# 010001
							current_type = GlobalZoneCube.SINGLE_FRONT_TOP
					else:
						if back_cube == null:
							# 010010
							current_type = GlobalZoneCube.SINGLE_BACK_TOP
						else:
							# 010011
							current_type = GlobalZoneCube.SINGLE_CENTER_TOP
				else:
					if front_cube == null:
						if back_cube == null:
							# 010100
							current_type = GlobalZoneCube.SINGLEROT_FRONT_TOP
						else:
							# 010101
							current_type = GlobalZoneCube.RIGHT_FRONT_TOP
					else:
						if back_cube == null:
							# 010110
							current_type = GlobalZoneCube.RIGHT_BACK_TOP
						else:
							# 010111
							current_type = GlobalZoneCube.RIGHT_CENTER_TOP
			else:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 011000
							current_type = GlobalZoneCube.SINGLEROT_BACK_TOP
						else:
							# 011001
							current_type = GlobalZoneCube.LEFT_FRONT_TOP
					else:
						if back_cube == null:
							# 011010
							current_type = GlobalZoneCube.LEFT_BACK_TOP
						else:
							# 011011
							current_type = GlobalZoneCube.LEFT_CENTER_TOP
				else:
					if front_cube == null:
						if back_cube == null:
							# 011100
							current_type = GlobalZoneCube.SINGLEROT_CENTER_TOP
						else:
							# 011101
							current_type = GlobalZoneCube.CENTER_FRONT_TOP
					else:
						if back_cube == null:
							# 011110
							current_type = GlobalZoneCube.CENTER_BACK_TOP
						else:
							# 011111
							current_type = GlobalZoneCube.CENTER_CENTER_TOP
	else:
		if bottom_cube == null:
			if right_cube == null:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 100000
							current_type = GlobalZoneCube.SINGLECOLUMN_FRONT_BOTTOM
						else:
							# 100001
							current_type = GlobalZoneCube.SINGLE_FRONT_BOTTOM
					else:
						if back_cube == null:
							# 100010
							current_type = GlobalZoneCube.SINGLE_BACK_BOTTOM
						else:
							# 100011
							current_type = GlobalZoneCube.SINGLE_CENTER_BOTTOM
				else:
					if front_cube == null:
						if back_cube == null:
							# 100100
							current_type = GlobalZoneCube.SINGLEROT_FRONT_BOTTOM
						else:
							# 100101
							current_type = GlobalZoneCube.RIGHT_FRONT_BOTTOM
					else:
						if back_cube == null:
							# 100110
							current_type = GlobalZoneCube.RIGHT_BACK_BOTTOM
						else:
							# 100111
							current_type = GlobalZoneCube.RIGHT_CENTER_BOTTOM
			else:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 101000
							current_type = GlobalZoneCube.SINGLEROT_BACK_BOTTOM
						else:
							# 101001
							current_type = GlobalZoneCube.LEFT_FRONT_BOTTOM
					else:
						if back_cube == null:
							# 101010
							current_type = GlobalZoneCube.LEFT_BACK_BOTTOM
						else:
							# 101011
							current_type = GlobalZoneCube.LEFT_CENTER_BOTTOM
				else:
					if front_cube == null:
						if back_cube == null:
							# 101100
							current_type = GlobalZoneCube.SINGLEROT_CENTER_BOTTOM
						else:
							# 101101
							current_type = GlobalZoneCube.CENTER_FRONT_BOTTOM
					else:
						if back_cube == null:
							# 101110
							current_type = GlobalZoneCube.CENTER_BACK_BOTTOM
						else:
							# 101111
							current_type = GlobalZoneCube.CENTER_CENTER_BOTTOM
		else:
			if right_cube == null:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 110000
							current_type = GlobalZoneCube.SINGLECOLUMN_FRONT_CENTER
						else:
							# 110001
							current_type = GlobalZoneCube.SINGLE_FRONT_CENTER
					else:
						if back_cube == null:
							# 110010
							current_type = GlobalZoneCube.SINGLE_BACK_CENTER
						else:
							# 110011
							current_type = GlobalZoneCube.SINGLE_CENTER_CENTER
				else:
					if front_cube == null:
						if back_cube == null:
							# 110100
							current_type = GlobalZoneCube.SINGLEROT_FRONT_CENTER
						else:
							# 110101
							current_type = GlobalZoneCube.RIGHT_FRONT_CENTER
					else:
						if back_cube == null:
							# 110110
							current_type = GlobalZoneCube.RIGHT_BACK_CENTER
						else:
							# 110111
							current_type = GlobalZoneCube.RIGHT_CENTER_CENTER
			else:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 111000
							current_type = GlobalZoneCube.SINGLEROT_BACK_CENTER
						else:
							# 111001
							current_type = GlobalZoneCube.LEFT_FRONT_CENTER
					else:
						if back_cube == null:
							# 111010
							current_type = GlobalZoneCube.LEFT_BACK_CENTER
						else:
							# 111011
							current_type = GlobalZoneCube.LEFT_CENTER_CENTER
				else:
					if front_cube == null:
						if back_cube == null:
							# 111100
							current_type = GlobalZoneCube.SINGLEROT_CENTER_CENTER
						else:
							# 111101
							current_type = GlobalZoneCube.CENTER_FRONT_CENTER
					else:
						if back_cube == null:
							# 111110
							current_type = GlobalZoneCube.CENTER_BACK_CENTER
						else:
							# 111111
							current_type = GlobalZoneCube.CENTER_CENTER_CENTER
"""
