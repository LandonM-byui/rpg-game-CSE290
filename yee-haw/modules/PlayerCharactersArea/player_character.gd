extends Node2D

var player_id = 0
var player_position = Vector2(0,0)
var player_health = 10
var current = false

func initialize(id: int, current: bool) -> void:
	player_id = id;
	current = current;
	
func _set_player_position(pos: Vector2) -> void:
	player_position = pos
