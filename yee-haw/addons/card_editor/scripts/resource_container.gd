@tool
extends Control
class_name ResourceContainer

func initialize(data: Resource, param: String):
	$"HBoxContainer/Label".text = param.capitalize()
	CESig.connect_resource($"HBoxContainer/RESOURCE PICKER", param, data)
	
