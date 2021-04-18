extends Node2D


onready var http : HTTPRequest = $HTTPRequest
onready var email : LineEdit = $UI/VBoxContainer/Email
onready var password : LineEdit = $UI/VBoxContainer/Password
onready var confirm : LineEdit = $UI/VBoxContainer/ConfirmPassword
onready var notification : Label = $UI/Notification


func _ready():
	pass


func _on_HomeButton_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response_body := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
	else:
		notification.text = "Registration done!"
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene("res://Scenes/Login.tscn")


func _on_RegisterButton_pressed():
	if password.text != confirm.text or email.text.empty() or password.text.empty():
		notification.text = "Invalid entry!!"
		return
	Firebase.register(email.text, password.text, http)
