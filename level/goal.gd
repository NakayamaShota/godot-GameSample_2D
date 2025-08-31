class_name Goal
extends Area2D
## Collectible that disappears when the player touches it.


@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var gameClear = $GameClear


func _on_body_entered(body: Node2D) -> void:
	animation_player.play(&"picked")
	(body as Player).coin_collected.emit()
	(body as Player).game_clear.emit()
	
