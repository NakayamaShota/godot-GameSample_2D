class_name CoinsCounter
extends Panel

#var _coins_collected: int = 0

@onready var _coins_label := $Label as Label


func _ready() -> void:
	_coins_label.set_text(str(g_singleton.get_coins_num()))
	($AnimatedSprite2D as AnimatedSprite2D).play()


func collect_coin() -> void:
	g_singleton.coins_num += 1
	_coins_label.set_text(str(g_singleton.get_coins_num()))
