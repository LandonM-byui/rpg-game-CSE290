extends Node

@export var layout_preset1 : EnemyLayoutPreset = preload("res://modules/enemy_grid_neils/layout/data/front_collumn.tres")
var approved_layout_preset1 : Array = layout_preset1.layout

func _on_ready():
	print(approved_layout_preset1)
	#for i in range(1,15):
		#var enemy = 
	
