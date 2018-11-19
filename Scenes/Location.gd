extends Spatial


var lite = preload("res://Prefabs/Locations/SimpleGround.tscn")
var dunes_01 = preload("res://Prefabs/Locations/Dune_01.tscn")


func _on_Game_update_location():
	for child in get_children():
		child.queue_free()
	
	match GlobalData.current_location:
		GlobalData.GameLocation.LITE:
			add_child(lite.instance())
		GlobalData.GameLocation.DUNES_01:
			add_child(dunes_01.instance())
		_:
			add_child(lite.instance())

