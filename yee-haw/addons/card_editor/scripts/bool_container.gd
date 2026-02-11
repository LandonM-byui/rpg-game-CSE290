@tool
extends Control
class_name BoolContainer

func initialize(data: Resource, param: String):
	$"HBoxContainer/Label".text = param.capitalize()
	CESig.connect_toggle($"HBoxContainer/BOOL VALUE", param, data)	
