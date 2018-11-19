extends Position3D

# целевая позиция объекта
var target_position = GlobalData.CAMERA_LOOK_AT_POSITION
# текущая позиция объекта
var current_position = Vector3()
var smoothness = 2

# игровай зона, в которой происходит заполнение
var game_zone = null
# нод главного объекта
var game_node = null


func _ready():
	game_node = $".."
	game_zone = $".."/GameZone
	
	current_position = target_position
	translation = current_position
	

func _process(delta):
	smooth_fall_by_y_position(delta)


func smooth_fall_by_y_position(delta):
	if not game_node.current_cube_is_exists():
		return
	
	var gn_pos = game_node.current_cube.translation
	var gz_top = game_zone.get_top_position_relatively(gn_pos)
	
	if gz_top == null:
		gz_top = Vector3()
	
	if gz_top.y >= gn_pos.y:
		return
	
	var half_gz_top_y = gz_top.y / 2.0
	target_position.y = ((gn_pos.y - half_gz_top_y) / 2.0) + half_gz_top_y
	
	target_position.x = gn_pos.x
	target_position.z = gn_pos.z
	
	current_position = current_position.linear_interpolate(target_position, smoothness * delta)
	
	translation = current_position

