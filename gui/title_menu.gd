extends Control
class_name TitleMenu

@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont := $ColorRect/CenterContainer as CenterContainer
@onready var coins_counter := $ColorRect/CoinsCounter as CoinsCounter
@onready var creditMenu = $Credit


func close() -> void:
	var tween := create_tween()
	get_tree().paused = false
	tween.tween_property(
		self,
		^"modulate:a",
		0.0,
		fade_out_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(
		center_cont,
		^"anchor_bottom",
		0.5,
		fade_out_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(hide)


func open() -> void:
	show()

	modulate.a = 0.0
	center_cont.anchor_bottom = 0.5
	var tween := create_tween()
	tween.tween_property(
		self,
		^"modulate:a",
		1.0,
		fade_in_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(
		center_cont,
		^"anchor_bottom",
		1.0,
		fade_out_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_start_button_pressed() -> void:
	g_singleton.playerPosition = ""
	g_singleton.coins_num = 0
	g_singleton.playerHp = 3
	g_singleton.newGameFlg = 1
	get_tree().change_scene_to_file("res://game_singleplayer.tscn")


## セーブデータのファイルパス.
const PATH_SAVEDATA = "user://savedata.txt"

func _on_load_button_pressed() -> void:
	close()
	get_tree().change_scene_to_file("res://game_singleplayer.tscn")

	if FileAccess.file_exists(PATH_SAVEDATA) == false:
		print("セーブデータが存在しません: %s"%PATH_SAVEDATA)
		return
	var f = FileAccess.open(PATH_SAVEDATA, FileAccess.READ)
	var s = f.get_as_text()
	# 文字列をセーブデータに変換.
	var savedata = str_to_var(s)
	var test = ""
	for chara in savedata["chara_list"]:
		g_singleton.playerPosition = chara["position"]		
		g_singleton.coins_num = chara["coins"]
		g_singleton.playerHp = chara["playerHp"]
		g_singleton.playerMaxHp = chara["playerMaxHp"]

		# ファイルを閉じる.
		f.close()


func _on_quit_button_pressed() -> void:
	if visible:
		get_tree().quit()


func _on_credit_button_pressed() -> void:
	creditMenu.creditOpen()

	
	
	
