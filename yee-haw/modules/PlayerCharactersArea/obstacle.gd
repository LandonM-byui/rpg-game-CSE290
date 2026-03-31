extends Node2D

@export var obstacle_name = ""
@export var color = ""
var health = 10
var rock_position = []

func instantiate(row, column):
	rock_position.append(row)
	rock_position.append(column)

func take_dmg(val):
	health -= 10
	death_check()
		

func death_check():
	if health <= 0:
		var row = rock_position[0]
		var col = rock_position[1]
		get_parent().player_grid_array[row][col] = null
		queue_free()
