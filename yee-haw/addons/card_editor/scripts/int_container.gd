@tool
extends Control
class_name IntContainer

func initialize(data: Resource, param: String):
	$HBoxContainer/Label.text = param.capitalize()
	CESig.connect_int($"HBoxContainer/INT VALUE".get_line_edit(), param, data)
