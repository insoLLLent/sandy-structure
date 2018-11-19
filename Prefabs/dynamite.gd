extends Spatial


signal bang_dynamite_sig
signal destroy_dynamite_sig


var game_zone_node = null


func _ready():
	game_zone_node = $"../../GameZone"


func _process(delta):
	if game_zone_node == null:
		set_process(false)
	
	if game_zone_node.current_zone[round(translation.x)][round(translation.y)][round(translation.z)].visible:
		destroy_dynamite()
		set_process(false)


func _on_BangTimer_timeout():
	# отспавнить взрыв
	
	var need_hide = []
	
	for x in range(translation.x-1, translation.x+2, 1):
		if (x < 0) or (x >= GlobalData.MAX_X_CUBES):
			continue
		
		for y in range(translation.y-1, translation.y+2, 1):
			if y < 0:
				continue
			
			for z in range(translation.z-1, translation.z+2, 1):
				if (z < 0) or (z >= GlobalData.MAX_X_CUBES):
					continue
				
				game_zone_node.current_zone[round(x)][round(y)][round(z)].hide()
	
	bang_dynamite()


func _on_dynamite_area_area_entered(area):
	destroy_dynamite()


func _on_dynamite_area_body_entered(body):
	destroy_dynamite()



# реакция на уничтожение динамита
func destroy_dynamite():
	emit_signal("destroy_dynamite_sig")
	# вспышка дыма
	queue_free()


# реакция на взрыв динамита
func bang_dynamite():
	emit_signal("bang_dynamite_sig")
	# вспышка от взрыка
	queue_free()

