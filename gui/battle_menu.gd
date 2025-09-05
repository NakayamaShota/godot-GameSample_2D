class_name  BattleMenu
extends Panel

@onready var hp1 := $Sprite2D_2 as Sprite2D
@onready var hp2 := $Sprite2D_3 as Sprite2D
@onready var hp3 := $Sprite2D_4 as Sprite2D



func _ready() -> void:
	if (g_singleton.playerHp == 2):
		hp1.show()
		hp2.show()
		hp3.hide()
	elif (g_singleton.playerHp == 1):
		hp1.show()
		hp2.hide()
		hp3.hide()
	elif (g_singleton.playerHp == 0):
		hp1.hide()
		hp2.hide()
		hp3.hide()

func _on_player_player_damage() -> void:
	hp1.hide()
	hp2.hide()
	hp3.hide()
	if (g_singleton.playerHp == 2):
		hp1.show()
		hp2.show()
		hp3.hide()
	elif (g_singleton.playerHp == 1):
		hp1.show()
		hp2.hide()
		hp3.hide()
	elif (g_singleton.playerHp == 0):
		hp1.hide()
		hp2.hide()
		hp3.hide()
