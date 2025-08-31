class_name PauseMenu
extends Control


@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont := $ColorRect/CenterContainer as CenterContainer
@onready var resume_button := center_cont.get_node(^"VBoxContainer/ResumeButton") as Button
@onready var coins_counter := $ColorRect/CoinsCounter as CoinsCounter

## セーブデータのファイルパス.
const PATH_SAVEDATA = "user://savedata.txt"


func _ready() -> void:
	hide()


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
	resume_button.grab_focus()

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


func _on_coin_collected() -> void:
	coins_counter.collect_coin()


func _on_resume_button_pressed() -> void:
	close()


func _on_start_button_pressed() -> void:
	if visible:
		# セーブデータを辞書型で定義.
		var savedata = {}

		# キャラデータ.   
		var player = {}
		player["name"] = "player"
		player["coins"] = g_singleton.get_coins_num()
		player["position"] = g_singleton.GetReference("Player").get_position()
		# キャラリスト
		var chara_list = [player]
		
		savedata["chara_list"] = chara_list	
		# ファイルを書き込みモードで開く.
		var f = FileAccess.open(PATH_SAVEDATA, FileAccess.WRITE)
		# セーブデータを文字列に変換.
		var s = var_to_str(savedata)
		f.store_string(s)
		# ファイルを閉じる.
		f.close()
	close()

func _on_load_button_pressed() -> void:
	if visible:
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
			print("-------------")
			print("name: %s"%chara["name"])
			print("coins: %s"%chara["coins"])
			g_singleton.playerPosition = chara["position"]		
			g_singleton.coins_num = chara["coins"]
			# ファイルを閉じる.
			f.close()

func _on_title_button_pressed() -> void:
	if visible:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://canvas_layer.tscn")

func _on_quit_button_pressed() -> void:
	if visible:
		get_tree().quit()
