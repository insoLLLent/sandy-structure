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


## long if
func _update_current_type():
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
							pass
					else:
						if back_cube == null:
							# 000010
							pass
						else:
							# 000011
							pass
				else:
					if front_cube == null:
						if back_cube == null:
							# 000100
							pass
						else:
							# 000101
							pass
					else:
						if back_cube == null:
							# 000110
							pass
						else:
							# 000111
							pass
			else:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 001000
							pass
						else:
							# 001001
							pass
					else:
						if back_cube == null:
							# 001010
							pass
						else:
							# 001011
							pass
				else:
					if front_cube == null:
						if back_cube == null:
							# 001100
							pass
						else:
							# 001101
							pass
					else:
						if back_cube == null:
							# 001110
							pass
						else:
							# 001111
							pass
		else:
			if right_cube == null:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 010000
							pass
						else:
							# 010001
							pass
					else:
						if back_cube == null:
							# 010010
							pass
						else:
							# 010011
							pass
				else:
					if front_cube == null:
						if back_cube == null:
							# 010100
							pass
						else:
							# 010101
							pass
					else:
						if back_cube == null:
							# 010110
							pass
						else:
							# 010111
							pass
			else:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 011000
							pass
						else:
							# 011001
							pass
					else:
						if back_cube == null:
							# 011010
							pass
						else:
							# 011011
							pass
				else:
					if front_cube == null:
						if back_cube == null:
							# 011100
							pass
						else:
							# 011101
							pass
					else:
						if back_cube == null:
							# 011110
							pass
						else:
							# 011111
							pass
	else:
		if bottom_cube == null:
			if right_cube == null:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 100000
							pass
						else:
							# 100001
							pass
					else:
						if back_cube == null:
							# 100010
							pass
						else:
							# 100011
							pass
				else:
					if front_cube == null:
						if back_cube == null:
							# 100100
							pass
						else:
							# 100101
							pass
					else:
						if back_cube == null:
							# 100110
							pass
						else:
							# 100111
							pass
			else:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 101000
							pass
						else:
							# 101001
							pass
					else:
						if back_cube == null:
							# 101010
							pass
						else:
							# 101011
							pass
				else:
					if front_cube == null:
						if back_cube == null:
							# 101100
							pass
						else:
							# 101101
							pass
					else:
						if back_cube == null:
							# 101110
							pass
						else:
							# 101111
							pass
		else:
			if right_cube == null:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 110000
							pass
						else:
							# 110001
							pass
					else:
						if back_cube == null:
							# 110010
							pass
						else:
							# 110011
							pass
				else:
					if front_cube == null:
						if back_cube == null:
							# 110100
							pass
						else:
							# 110101
							pass
					else:
						if back_cube == null:
							# 110110
							pass
						else:
							# 110111
							pass
			else:
				if left_cube == null:
					if front_cube == null:
						if back_cube == null:
							# 111000
							pass
						else:
							# 111001
							pass
					else:
						if back_cube == null:
							# 111010
							pass
						else:
							# 111011
							pass
				else:
					if front_cube == null:
						if back_cube == null:
							# 111100
							pass
						else:
							# 111101
							pass
					else:
						if back_cube == null:
							# 111110
							pass
						else:
							# 111111
							pass

