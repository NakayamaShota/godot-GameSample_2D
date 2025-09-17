class_name GameOver
extends Control

func _ready() -> void:
	hide()


func _on_player_game_over() -> void:
	show()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://scene/title.tscn")
