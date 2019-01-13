extends Node

var global_ambient_stream = null

func _ready():
	global_ambient_stream = AudioStreamPlayer.new()
	add_child(global_ambient_stream)
	global_ambient_stream.stream = load("res://Sound/ambient.ogg")
	global_ambient_stream.volume_db = 0
	global_ambient_stream.pitch_scale = 1
	global_ambient_stream.playing = true
	global_ambient_stream.autoplay = true
	global_ambient_stream.mix_target = AudioStreamPlayer.MIX_TARGET_STEREO
	global_ambient_stream.bus = "Master1"
	global_ambient_stream.play()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
