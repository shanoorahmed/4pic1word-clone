extends Node2D


onready var http : HTTPRequest = $HTTPRequest

var s = 0
var hr_in = 0
var min_in = 0
var new_profile := false
var information_sent := false
var profile := {
	"level": {},
	"score": {},
	"hour": {},
	"minute": {},
	"actual_time": {}
}

var answer = []


func _ready():
	Firebase.get_document("users/%s" % Firebase.user_info.id, http)


func _on_HomeButton_pressed():
	get_tree().change_scene("res://Scenes/LoadGame.tscn")


func _process(delta):
	get_node("UI/AnswerNode/AnsweBox/Answer").text = str(answer)


func _on_NextButton_pressed():
	var l = 12
	var time = OS.get_time()
	var hour = int(time.hour)
	var minute = int(time.minute)
	var mins
	if(hour-hr_in==0):
		mins = minute-min_in
	elif(hour-hr_in==1):
		mins = minute+60-min_in
	if(mins<3):
		s += 10
	elif(mins<6):
		s += 9
	elif(mins<9):
		s += 8
	elif(mins<12):
		s += 7
	elif(mins<15):
		s += 6
	elif(mins<18):
		s += 5
	elif(mins<21):
		s += 4
	elif(mins<24):
		s += 3
	elif(mins<27):
		s += 2
	else:
		s += 1
	profile.level = { "integerValue": l }
	profile.score = { "integerValue": s }
	profile.hour = { "integerValue": hour }
	profile.minute = { "integerValue": minute }
	profile.actual_time = { "stringValue": String(time) }
	match new_profile:
		true:
			Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
		false:
			Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	information_sent = true
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://Scenes/Level12.tscn")


func _on_TryAgainButton_pressed():
	get_node("UI/PicturesNode").move(Vector2(0,0))
	get_node("UI/TryAgainNode").move(Vector2(-576,0))
	get_node("UI/AnswerNode").move(Vector2(0,0))


func _on_DeleteButton_pressed():
	answer.pop_back()


func _on_LetterButton1_pressed():
	if(answer.size()<8):
		answer.append("K")


func _on_LetterButton2_pressed():
	if(answer.size()<8):
		answer.append("A")


func _on_LetterButton3_pressed():
	if(answer.size()<8):
		answer.append("C")


func _on_LetterButton4_pressed():
	if(answer.size()<8):
		answer.append("H")


func _on_LetterButton5_pressed():
	if(answer.size()<8):
		answer.append("V")


func _on_LetterButton6_pressed():
	if(answer.size()<8):
		answer.append("W")


func _on_LetterButton7_pressed():
	if(answer.size()<8):
		answer.append("F")


func _on_LetterButton8_pressed():
	if(answer.size()<8):
		answer.append("R")


func _on_LetterButton9_pressed():
	if(answer.size()<8):
		answer.append("E")


func _on_LetterButton10_pressed():
	if(answer.size()<8):
		answer.append("O")


func _on_LetterButton11_pressed():
	if(answer.size()<8):
		answer.append("Y")


func _on_LetterButton12_pressed():
	if(answer.size()<8):
		answer.append("M")


func _on_LetterButton13_pressed():
	if(answer.size()<8):
		answer.append("N")


func _on_LetterButton14_pressed():
	if(answer.size()<8):
		answer.append("I")


func _on_OKButton_pressed():
	if(str(answer) == "[V, E, R, I, F, Y]"):
		get_node("UI/PicturesNode").move(Vector2(-576,0))
		get_node("UI/NextNode").move(Vector2(0,0))
		get_node("UI/AnswerNode").move(Vector2(-576,0))
	else:
		get_node("UI/PicturesNode").move(Vector2(576,0))
		get_node("UI/TryAgainNode").move(Vector2(0,0))
		get_node("UI/AnswerNode").move(Vector2(576,0))


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary
	s += int(result_body.fields.score.integerValue)
	hr_in += int(result_body.fields.hour.integerValue)
	min_in += int(result_body.fields.minute.integerValue)
	match response_code:
		404:
			new_profile = true
			return
		200:
			if information_sent:
				information_sent = false
			self.profile = result_body.fields


func _on_SkipButton_pressed():
	var l = 12
	s += 0
	var time = OS.get_time()
	var hour = int(time.hour)
	var minute = int(time.minute)
	profile.level = { "integerValue": l }
	profile.score = { "integerValue": s }
	profile.hour = { "integerValue": hour }
	profile.minute = { "integerValue": minute }
	profile.actual_time = { "stringValue": String(time) }
	match new_profile:
		true:
			Firebase.save_document("users?documentId=%s" % Firebase.user_info.id, profile, http)
		false:
			Firebase.update_document("users/%s" % Firebase.user_info.id, profile, http)
	information_sent = true
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://Scenes/Level12.tscn")
