
extends Node2D
@export var player_characters_scene: PackedScene
@export var obstacles_scene: PackedScene
var player_character_array = ["Miner", "Hunter", "Scout"]
var character_current_index = 0;
var player_grid_array = [["","",""],["","",""],["","",""],["","",""],["","",""]]
var player_grid_possitions = [[Vector2(-300, -600), Vector2(0, -600), Vector2(300, -600)],[Vector2(-300, -300), Vector2(0, -300), Vector2(300, -300)], [Vector2(-300, 0), Vector2(0, 0), Vector2(300, 0)], [Vector2(-300, 300), Vector2(0, 300), Vector2(300, 300)], [Vector2(-300, 600), Vector2(0, 600), Vector2(300, 600)]]



func _ready() -> void:
	randomize()
	_set_up_obstacles(3)
	_set_up_characters(player_character_array)
	
	for row in player_grid_array:
		print(row)
	
	#var pc = player_characters_scene.instantiate()
	#pc._set_player_position(Vector2(600, 600))
	#add_child(pc)
	
func _process(delta: float) -> void:
	if (not player_characters_scene):
		return
	else:
		pass
	if Input.is_action_pressed("Cycle_PCs"):
		_cycle_hero()
		
		
func _set_up_characters(characters) -> void:
	for char in characters:
		var pc = player_characters_scene.instantiate()
		pc.position = _find_random_spot(char)
		add_child(pc)
		
func _set_up_obstacles(num: int) -> void:
	var n = num
	var temp;
	while n != 0:
		var ob = obstacles_scene.instantiate()
		ob.position = _find_random_spot("rock")
		add_child(ob)
		n -= 1
		
		
func _find_random_spot(str) -> Vector2:
	var check = true
	var row;
	var column
	while check:
		row = randi() % 5
		column = randi() % 3
		if player_grid_array[row][column] == "":
			player_grid_array[row][column] = str
			check = false
	return player_grid_possitions[row][column]
	

## Use the up arrow to cycle through the characters needs cooldown
func _cycle_hero() -> void:
	if (character_current_index < player_character_array.size() -1):
		character_current_index += 1
	else:
		character_current_index = 0
	print(player_character_array[character_current_index])
	
func _path_clear(hero) -> bool:
	var row = 0;
	var column = 0;
	for r in player_grid_array:
		if r.has(hero):
			column = r.find(hero)
			if (column == r.length - 1):
				return true
			else:
				for n in range(column +1, r.size()):
					if r[n] != "":
						return false
				return true
	return false ## It wants this here for some reason
	
	
