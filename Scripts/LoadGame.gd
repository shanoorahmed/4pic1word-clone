extends Node2D

onready var http : HTTPRequest = $HTTPRequest

var new_profile := false
var information_sent := false
var profile := {
	"level": {},
	"score": {}
}
var game_level = 0


func _ready():
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	game_level += int(result_body.fields.level.integerValue)
	match response_code:
		404:
			new_profile = true
			return
		200:
			if information_sent:
				information_sent = false
			self.profile = result_body.fields


func _on_NewGame_pressed():
	var l = 1
	var s = 0
	profile.level = { "integerValue": l }
	profile.score = { "integerValue": s }
	match new_profile:
		true:
			Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
		false:
			Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	information_sent = true
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://Scenes/Level1.tscn")


func _on_Rules_pressed():
	pass # Replace with function body.


func _on_LoadGame_pressed():
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://Scenes/Level" + str(game_level) + ".tscn")
