extends Node2D


func _ready():
	pass


func _on_LoginButton_pressed():
	get_tree().change_scene("res://Scenes/Login.tscn")


func _on_RegisterButton_pressed():	
	get_tree().change_scene("res://Scenes/Register.tscn")
