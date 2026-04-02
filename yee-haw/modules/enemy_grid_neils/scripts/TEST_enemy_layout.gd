extends Node

#@export var layout_preset1 : EnemyLayoutPreset = preload("res://modules/enemy_grid_neils/layout/data/front_collumn.tres")
#var approved_layout_preset1 : Array = layout_preset1.layout

@export var enemy_scene : PackedScene

func _ready():
	instantiate_enemy()
	

func instantiate_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(300, 300)
	add_child(enemy)
	
	enemy.show()
