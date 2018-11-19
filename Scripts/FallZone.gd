extends Spatial


var fillerCubePath = preload("res://Prefabs/FallZoneCube/FallZoneCube.tscn")

# представление зоны подсветки
var current_zone = []
# координаты отображаемых блоков зоны подсветки
var current_visualise = []


func _enter_tree():
	generate_zone()


# заполнение зоны подсветки невидимыми кубами 
func generate_zone():
	for x in range(GlobalData.MAX_X_CUBES):
		for y in range(GlobalData.MAX_Y_CUBES):
			current_zone.append([])
			for z in range(GlobalData.MAX_Z_CUBES):
				current_zone[x].append([])
				current_zone[x][y].append(fillerCubePath.instance())
				add_child(current_zone[x][y][z])
				current_zone[x][y][z].translation = Vector3(x, y, z)
				current_zone[x][y][z].hide()


func hide_current_visualise():
	for coord in current_visualise:
		current_zone[coord.x][coord.y][coord.z].hide()

func show_current_visualise():
	for coord in current_visualise:
		current_zone[coord.x][coord.y][coord.z].show()

func new_current_visualise(coords):
	current_visualise.clear()
	
	for coord in coords:
		var new_coord = Vector3(round(coord.x), round(coord.y), round(coord.z))
		current_visualise.append(new_coord)
