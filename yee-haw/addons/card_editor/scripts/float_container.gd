@tool
extends Control
class_name FloatContainer

func initialize(data: Resource, param: String):
	$HBoxContainer/Label.text = param.capitalize()
	CESig.connect_float($"HBoxContainer/FLOAT VALUE".get_line_edit(), param, data)
	