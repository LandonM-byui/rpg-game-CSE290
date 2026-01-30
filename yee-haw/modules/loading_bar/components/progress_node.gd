@tool
extends Control
class_name ProgressNode

@export var fill_box : ColorRect

func set_node_color(color: Color) -> void:
	fill_box.color = color
