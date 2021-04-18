extends Node2D

onready var http : HTTPRequest = $HTTPRequest
onready var rollnumber : LineEdit = $UI/LoginButtons/VBoxContainer/RollNumber

var new_profile := false
var information_sent := false
var profile := {
	"level": {},
	"score": {},
	"hour": {},
	"minute": {},
	"actual_time": {},
	"roll_number": {}
}
var game_level = 0


func _ready():
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	match response_code:
		404:
			new_profile = true
			return
		200:
			if information_sent:
				information_sent = false
			self.profile = result_body.fields
	match new_profile:
		false:
			game_level += int(result_body.fields.level.integerValue)


func _on_NewGame_pressed():
	var l = 1
	var s = 0
	var time = OS.get_time()
	var hour = int(time.hour)
	var minute = int(time.minute)
	if !rollnumber.text.empty() and str(rollnumber.text).length()==9:
		profile.level = { "integerValue": l }
		profile.score = { "integerValue": s }
		profile.hour = { "integerValue": hour }
		profile.minute = { "integerValue": minute }
		profile.actual_time = { "stringValue": String(time) }
		profile.roll_number = { "stringValue": String(rollnumber.text) }
		match new_profile:
			true:
				Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
				information_sent = true
				yield(get_tree().create_timer(2.0), "timeout")
				get_tree().change_scene("res://Scenes/Level1.tscn")


func _on_Rules_pressed():
	get_tree().change_scene("res://Scenes/Rules.tscn")


func _on_LoadGame_pressed():
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://Scenes/Level" + str(game_level) + ".tscn")
