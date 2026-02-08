@tool
extends Control

## Tracks a Control as node in a [LevelProgressBar]
class_name ProgressNode

## UI element that changes color during progress
@export var fill_box : ColorRect

## Sets the UI color to the given color
## [br][param color] color to set node to
func set_node_color(color: Color) -> void:
	fill_box.color = color
