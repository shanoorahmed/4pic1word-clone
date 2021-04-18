extends Node2D


func _ready():
	pass # Replace with function body.


func _on_OKButton_pressed():
	get_tree().change_scene("res://Scenes/LoadGame.tscn")
