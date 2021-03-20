extends Node2D


onready var http : HTTPRequest = $HTTPRequest
onready var rollnumber : LineEdit = $UI/VBoxContainer/RollNumber
onready var email : LineEdit = $UI/VBoxContainer/Email
onready var password : LineEdit = $UI/VBoxContainer/Password
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
		notification.text = "Login Successful!"
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://Scenes/LoadGame.tscn")


func _on_LoginButton_pressed():
	if rollnumber.text.empty() or str(rollnumber.text).length()!=9 or email.text.empty() or password.text.empty():
		notification.text = "Invalid entry!!"
		return
	Firebase.login(email.text, password.text, http)
