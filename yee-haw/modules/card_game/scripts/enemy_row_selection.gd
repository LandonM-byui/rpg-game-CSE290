extends EnemySelectionArea
class_name EnemyRowSelection

@export var nodes : Array[Node2D]

func select() -> void:
	for node in nodes:
		node.modulate = SELECTION_COLOR

func deselect() -> void:
	for node in nodes:
		node.modulate = NORMAL_COLOR