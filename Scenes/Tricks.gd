extends Spatial


signal dynamite_sig


enum EnumTrick { DYNAMITE }


var dynamite = preload("res://Prefabs/dynamite.tscn")


var game_zone_node = null


func _ready():
	game_zone_node = $"../GameZone"


func _on_Game_make_trick_sig():
	randomize()
	match randi() % EnumTrick.size():
		EnumTrick.DYNAMITE:
			spawn_dynamite()


func spawn_dynamite():
	var top_position = game_zone_node.get_top_position()
	var visualised_blocks = game_zone_node.get_list_all_visualised_blocks()
	
	if (top_position == null) or visualised_blocks.empty():
		return
	
	
	var empty_block = []
	
	for x in range(GlobalData.MAX_X_CUBES):
		for y in range(top_position.y + 1):
			for z in range(GlobalData.MAX_Z_CUBES):
				if not visualised_blocks[x][y][z] and \
				   ((y == 0) or ((y > 0) and visualised_blocks[x][y-1][z])):
					
					empty_block.append(Vector3(x, y, z))
	
	visualised_blocks.clear()
	
	randomize()
	var dynamite_translation = empty_block[randi() % empty_block.size()]
	
	empty_block.clear()
	
	var new_dynamite_node = dynamite.instance()
	add_child(new_dynamite_node)
	new_dynamite_node.translation = dynamite_translation
	
	emit_signal("dynamite_sig")

