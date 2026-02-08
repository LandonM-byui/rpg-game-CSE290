extends Node2D
## Defines an enemy area as selectable.
class_name EnemySelectionArea

## Modulation color when the area is selected.
const SELECTION_COLOR : Color = Color(1.0, 0.6745098, 0.6745098)
## Modulation color when the area is deselected.
const NORMAL_COLOR : Color = Color(1.0, 1.0, 1.0)

## Colors the VFX to signify the area is selected.
func select() -> void:
	modulate = SELECTION_COLOR

## Colors the VFX to signify the area is not selected.
func deselect() -> void:
	modulate = NORMAL_COLOR

func _ready() -> void:
	# initial color state is deselected
	deselect()