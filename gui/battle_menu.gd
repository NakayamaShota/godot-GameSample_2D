class_name  BattleMenu
extends Panel

@onready var hp1 := $Sprite2D_2 as Sprite2D
@onready var hp2 := $Sprite2D_3 as Sprite2D
@onready var hp3 := $Sprite2D_4 as Sprite2D
@onready var hp_bar := $PlayerHpBar as ProgressBar



func _ready() -> void:
	hp_bar.value = 100 * g_singleton.playerHp / g_singleton.playerMaxHp

func _on_player_player_damage() -> void:
	hp_bar.value = 100 * g_singleton.playerHp / g_singleton.playerMaxHp
