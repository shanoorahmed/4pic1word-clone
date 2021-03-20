extends Node2D


onready var http : HTTPRequest = $HTTPRequest

var time = 0
var mins = 0
var timer_on = true
var s = 0
var new_profile := false
var information_sent := false
var profile := {
	"level": {},
	"score": {}
}

var answer = []


func _ready():
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)


func _process(delta):
	get_node("UI/AnswerNode/AnsweBox/Answer").text = str(answer)
	if(timer_on):
		time += delta
		mins = floor(time/60)


func _on_HomeButton_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	s += int(result_body.fields.score.integerValue)
	match response_code:
		404:
			new_profile = true
			return
		200:
			if information_sent:
				information_sent = false
			self.profile = result_body.fields


func _on_NextButton_pressed():
	var l = 2
	if(mins<2):
		s += 10
	else:
		s += (10/mins)
	profile.level = { "integerValue": l }
	profile.score = { "integerValue": s }
	match new_profile:
		true:
			Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
		false:
			Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	information_sent = true
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://Scenes/Level2.tscn")


func _on_TryAgainButton_pressed():
	get_node("UI/PicturesNode").move(Vector2(0,0))
	get_node("UI/TryAgainNode").move(Vector2(-576,0))
	get_node("UI/AnswerNode").move(Vector2(0,0))
	timer_on = true


func _on_DeleteButton_pressed():
	answer.pop_back()


func _on_LetterButton1_pressed():
	if(answer.size()<8):
		answer.append("A")


func _on_LetterButton2_pressed():
	if(answer.size()<8):
		answer.append("U")


func _on_LetterButton3_pressed():
	if(answer.size()<8):
		answer.append("O")


func _on_LetterButton4_pressed():
	if(answer.size()<8):
		answer.append("H")


func _on_LetterButton5_pressed():
	if(answer.size()<8):
		answer.append("M")


func _on_LetterButton6_pressed():
	if(answer.size()<8):
		answer.append("W")


func _on_LetterButton7_pressed():
	if(answer.size()<8):
		answer.append("S")


func _on_LetterButton8_pressed():
	if(answer.size()<8):
		answer.append("R")


func _on_LetterButton9_pressed():
	if(answer.size()<8):
		answer.append("E")


func _on_LetterButton10_pressed():
	if(answer.size()<8):
		answer.append("D")


func _on_LetterButton11_pressed():
	if(answer.size()<8):
		answer.append("T")


func _on_LetterButton12_pressed():
	if(answer.size()<8):
		answer.append("D")


func _on_LetterButton13_pressed():
	if(answer.size()<8):
		answer.append("N")


func _on_LetterButton14_pressed():
	if(answer.size()<8):
		answer.append("Y")


func _on_OKButton_pressed():
	timer_on = false
	if(str(answer) == "[S, U, M, M, E, R]"):
		get_node("UI/PicturesNode").move(Vector2(-576,0))
		get_node("UI/NextNode").move(Vector2(0,0))
		get_node("UI/AnswerNode").move(Vector2(-576,0))
	else:
		get_node("UI/PicturesNode").move(Vector2(576,0))
		get_node("UI/TryAgainNode").move(Vector2(0,0))
		get_node("UI/AnswerNode").move(Vector2(576,0))


func _on_SkipButton_pressed():
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://Scenes/Level2.tscn")
