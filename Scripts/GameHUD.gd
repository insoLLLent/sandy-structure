extends Control


var counter_score_node = null
var counter_speed_node = null

func _ready():
	counter_score_node = $"MarginContainer/VBoxContainer/ScoreContainer/CounterLabel"
	counter_speed_node = $"MarginContainer/VBoxContainer/SpeedContainer/CounterLabel"


func _on_Game_update_score_sig(current_score):
	counter_score_node.text = str(current_score)
