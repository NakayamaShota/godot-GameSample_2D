class_name GameClear
extends Control
@onready var player :=  $"../../Level/Player" as Player

func _ready() -> void:
	hide()

func _on_player_game_clear() -> void:
	show()
	g_singleton.playerPosition = ""
	player.dialogue("gameClear")
