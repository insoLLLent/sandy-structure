extends Spatial

# список локаций игры
var locations = {
	GlobalData.GameLocation.LITE: preload("res://Prefabs/Locations/SimpleGround.tscn"),
	GlobalData.GameLocation.DUNES_01: preload("res://Prefabs/Locations/Dune_01.tscn"),
}


# главный узел Game издает сигнал update_location, который запускает этот метод
func _on_Game_update_location():
	for child in get_children():
		child.queue_free()
	
	add_child(locations[GlobalData.current_location].instance())

