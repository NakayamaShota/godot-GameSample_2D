extends Area2D
@onready var saishonomachi := $saishonomachi as Sprite2D
@onready var menu := $"../../../CenterContainer2" as CenterContainer


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event.is_action_pressed("click")) :
		if(menu.visible == true):
			menu.visible = false
		elif(menu.visible == false):
			menu.visible = true
		#tweenの作成
		#var tween = get_tree().create_tween()
		# 1秒かけて透明にする
		#tween.tween_property(saishonomachi, "modulate", Color(0.28,0.43,0.63,0), 0.5).set_trans(Tween.TRANS_CUBIC)
		# 1秒かけて不透明にする
		#tween.tween_property(saishonomachi, "modulate", Color(1,1,1,1), 0.5).set_trans(Tween.TRANS_CUBIC)


func _on_mouse_entered() -> void:
	saishonomachi.modulate = Color(0.28,0.43,0.63)


func _on_mouse_exited() -> void:
	saishonomachi.modulate = Color(1,1,1)
