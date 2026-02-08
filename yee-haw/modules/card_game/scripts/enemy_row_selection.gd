extends EnemySelectionArea
## Defines an entire enemy row as a selection area.
class_name EnemyRowSelection

## All nodes contained within this row.
@export var nodes : Array[Node2D]

func select() -> void:
	for node in nodes:
		node.modulate = SELECTION_COLOR

func deselect() -> void:
	for node in nodes:
		node.modulate = NORMAL_COLOR