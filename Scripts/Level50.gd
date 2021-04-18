extends Node2D


func _ready():
	pass


func _on_HomeButton_pressed():
	get_tree().change_scene("res://Scenes/LoadGame.tscn")
