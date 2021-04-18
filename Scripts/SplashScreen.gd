extends Node2D


func _ready():
	yield(get_tree().create_timer(5.0), "timeout")
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_Timer_timeout():
	$Background/LoadingBar.value += 23
