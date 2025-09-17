extends Control
class_name credit

func _ready() -> void:
	hide()
	
func creditOpen() -> void:
	show()

func creditClose() -> void:
	hide()

func _input(event):
	if event is InputEventMouseButton:
		hide()
	
