extends EnemySelectionArea
class_name GridSelectionArea

@export var all_rows : Array[Node2D]

func select() -> void:
	for row in all_rows:
		for child in row.get_children():
			if not child is Node2D:
				continue
			child.modulate = SELECTION_COLOR

func deselect() -> void:
	for row in all_rows:
		for child in row.get_children():
			if not child is Node2D:
				continue
			child.modulate = NORMAL_COLOR