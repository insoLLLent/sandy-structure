extends Control


var counter_label_node = null
var fps_label_node = null

func _ready():
	counter_label_node = $"MarginContainer/VBoxContainer/ScoreContainer/CounterLabel"
	fps_label_node = $"MarginContainer/VBoxContainer/TestFPS/FPSLabel"


func _process(delta):
	fps_label_node.text = str(Engine.get_frames_per_second())


func _on_Game_update_score_sig(current_score):
	counter_label_node.text = str(current_score)
