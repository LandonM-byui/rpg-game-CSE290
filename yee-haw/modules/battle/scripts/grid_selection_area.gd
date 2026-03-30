extends EnemySelectionArea
## Defines an entire enemy grid as a selection area.
class_name GridSelectionArea

## Every row containing all enemy selection nodes
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