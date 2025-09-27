extends Control
class_name StrategyMenu

@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_cont := $ColorRect/CenterContainer as CenterContainer
@onready var castle := $ColorRect/ParallaxBackground/ParallaxLayer/Castle/castle as Sprite2D
@onready var animationPlayer := $Tutorial as AnimationPlayer
@onready var child_1 := $Tutorial/child1 as Sprite2D
@onready var child_2 := $Tutorial/child2 as Sprite2D
@onready var bard := $Tutorial/bard as Sprite2D
@onready var bar := $Tutorial/bar as Sprite2D


## セーブデータのファイルパス.
const PATH_SAVEDATA = "user://savedata.txt"

func _ready() -> void:
	if g_singleton.progress == "newgame":
		op_play()

func op_play() -> void:
	center_cont.visible = false
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	#tweenの作成
	var tween = get_tree().create_tween()
	tween.tween_property(castle, "modulate", Color(255,194,29,0), 1).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(castle, "modulate", Color(1,1,1,1), 1).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(2.3).timeout
	DialogueManager.show_dialogue_balloon(load("res://dialogue/opening.dialogue"), "narration")
	await DialogueManager.dialogue_ended
	bar.visible = true
	child_1.visible = true
	child_2.visible = true
	animationPlayer.play("children")
	DialogueManager.show_dialogue_balloon(load("res://dialogue/opening.dialogue"), "children")
	await DialogueManager.dialogue_ended
	bard.visible = true
	DialogueManager.show_dialogue_balloon(load("res://dialogue/opening.dialogue"), "start")
	await DialogueManager.dialogue_ended
	child_1.visible = false
	child_2.visible = false
	bard.visible = false
	bar.visible = false

	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	center_cont.visible = true

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
	if visible:
		# セーブデータを辞書型で定義.
		var savedata = {}

		# キャラデータ.   
		var player = {}
		player["name"] = "player"
		player["coins"] = g_singleton.coins_num
		#player["position"] = g_singleton.GetReference("Player").get_position()
		player["playerHp"] = g_singleton.playerHp
		player["playerMaxHp"] = g_singleton.playerMaxHp

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
	close()
	get_tree().change_scene_to_file("res://scene/game_singleplayer.tscn")

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
		get_tree().quit()
	
	


func _on_attack_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/game_singleplayer.tscn")

func _on_rest_button_pressed() -> void:
	DialogueManager.show_dialogue_balloon(load("res://scene/dialogue/tutorial.dialogue"), "start")

func _on_explain_button_pressed() -> void:
	DialogueManager.show_dialogue_balloon(load("res://scene/dialogue/tutorial.dialogue"), "start")

func _on_event_button_pressed() -> void:
	DialogueManager.show_dialogue_balloon(load("res://scene/dialogue/tutorial.dialogue"), "start")
