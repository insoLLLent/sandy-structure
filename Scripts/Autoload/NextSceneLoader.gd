extends Node

"""
Синглтон; реализующий предзагрузку сцен.
"""

var loader
var wait_frames
var time_max = 2 # msec
var current_scene

var loader_scene_preload = preload("res://Scenes/Loader.tscn")
var loader_node_name = "Loader"
var loader_progress_path = "Loader/Control/MarginContainer/HBoxContainer/VBoxContainer2/progress"


func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	#preload_materials()


func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	
	if wait_frames > 0: # wait for frames to let the "loading" animation to show up
		wait_frames -= 1
		return
	
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
	
		# poll your loader
		var err = loader.poll()
		
		if err == ERR_FILE_EOF: # load finished
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			get_tree().root.get_node(loader_node_name).queue_free()
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			show_error()
			loader = null
			break


func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	
	if loader == null: # check for errors
		show_error()
		return
	
	set_process(true)
	
	current_scene.queue_free()
	
	get_tree().change_scene_to(loader_scene_preload)
	
	wait_frames = 1


func update_progress():
	var progress = 100 * loader.get_stage() / loader.get_stage_count()
	# update your progress bar?
	get_tree().root.get_node(loader_progress_path).value = progress


func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_tree().root.add_child(current_scene)



#####################

# Предзагрузка материалов, чтобы игра не подвисала в процессе
# первоначального инстанцирования объекта.
# На данный момент отключена.
func preload_materials():
	var dir = "res://Models/"
	var dh = Directory.new()
	
	var materials = []
	
	if dh.open(dir) == OK:
		dh.list_dir_begin()
		
		var file_name = dh.get_next()
		
		while (file_name != ""):
			if not dh.current_is_dir():
				if file_name.ends_with(".material"):
					materials.append(load(dir + file_name))
			
			file_name = dh.get_next()
	else:
		return
	
	if materials.empty():
		return
	
	for mat in materials:
		var tmp_mesh = MeshInstance.new()
		tmp_mesh.mesh = CubeMesh.new()
		add_child(tmp_mesh)
		tmp_mesh.material_override = mat


#####################


