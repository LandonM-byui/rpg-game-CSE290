@tool
extends Control
class_name EnumContainer

func initialize(data: Resource, param: String) -> void:
	$HBoxContainer/Label.text = param.capitalize()
	CESig.connect_enum($"HBoxContainer/ENUM VALUE", param, data)
	