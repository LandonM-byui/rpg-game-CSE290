extends Node2D
class_name EnemySelectionArea

const SELECTION_COLOR : Color = Color(1.0, 0.6745098, 0.6745098)
const NORMAL_COLOR : Color = Color(1.0, 1.0, 1.0)

func select() -> void:
	modulate = SELECTION_COLOR

func deselect() -> void:
	modulate = NORMAL_COLOR
	
func _ready() -> void:
	deselect()