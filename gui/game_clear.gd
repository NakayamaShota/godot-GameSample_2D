class_name GameClear
extends Control

func _ready() -> void:
	hide()

func _on_player_game_clear() -> void:
	show()
	DialogueManager.show_dialogue_balloon(load("res://dialogue/clear_message.dialogue"), "start")
	g_singleton.playerPosition = ""
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://title.tscn")
	
