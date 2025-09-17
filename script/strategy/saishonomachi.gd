extends Area2D
@onready var saishonomachi := $saishonomachi as Sprite2D
@onready var menu := $"../../../CenterContainer2" as CenterContainer
@onready var attackButton := $"../../../CenterContainer2/VBoxContainer/AttackButton" as Button
@onready var restButton := $"../../../CenterContainer2/VBoxContainer/RestButton" as Button
@onready var explainButton := $"../../../CenterContainer2/VBoxContainer/ExplainButton" as Button
@onready var eventButton := $"../../../CenterContainer2/VBoxContainer/EventButton" as Button

var color_val : Color

func _ready() -> void:
	color_val = saishonomachi.modulate

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_pressed("click")) :
		attackButton.visible = false
		restButton.visible = false
		explainButton.visible = false
		eventButton.visible = false
		if(menu.visible == true):
			menu.visible = false
		elif(menu.visible == false):
			menu.visible = true
			attackButton.visible = true
			restButton.visible = true
			eventButton.visible = true
		#tweenの作成
		#var tween = get_tree().create_tween()
		# 1秒かけて透明にする
		#tween.tween_property(saishonomachi, "modulate", Color(0.28,0.43,0.63,0), 0.5).set_trans(Tween.TRANS_CUBIC)
		# 1秒かけて不透明にする
		#tween.tween_property(saishonomachi, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_CUBIC)


func _on_mouse_entered() -> void:
	saishonomachi.modulate = Color(0.28,0.43,0.63)


func _on_mouse_exited() -> void:
	saishonomachi.modulate = color_val
