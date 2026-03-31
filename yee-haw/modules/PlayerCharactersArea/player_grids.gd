
extends Node2D
@export var player_characters_scene: PackedScene
@export var obstacles_scene: PackedScene
@export var player_grid_scene: PackedScene

var player_character_array := ["Miner", "Hunter", "Scout"]
var character_current_index := 0;
var player_grid_array := [[null,null,null],[null,null,null],[null,null,null],[null,null,null],[null,null,null]]
var grid := []
@export var player_grid_rows : Array[float] = [-300, -150, 0, 150, 300]
@export var player_grid_columns : Array[float] = [-300, 0, 300]
var player_grid_positions : Array
var selected_player = null
var selected_player_pos := 0;


func _ready() -> void:
	player_grid_positions = []
	for row in player_grid_rows:
		var data : Array[Vector2] = []
		for col in player_grid_columns:
			data.append(Vector2(col, row))
		player_grid_positions.append(data)

	randomize()
	grid.clear()
	grid = [[null,null,null],[null,null,null],[null,null,null],[null,null,null],[null,null,null]]
	for r in range(player_grid_positions.size()):
		for c in range(player_grid_positions[r].size()):
			grid[r][c] = player_grid_scene.instantiate()
			grid[r][c].initialize(r, c)
			grid[r][c].position = player_grid_positions[r][c]
			grid[r][c].tile_clicked.connect(_on_tile_clicked)
			add_child(grid[r][c])
	_set_up_obstacles(3)
	_set_up_characters(player_character_array)
	
	#var pc = player_characters_scene.instantiate()
	#pc._set_player_position(Vector2(600, 600))
	#add_child(pc)
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("Cycle_PCs"):
		_reset_turn()
		
		
func _set_up_characters(characters) -> void:
	var i := 0
	for character in characters:
		var pc := player_characters_scene.instantiate()
		var grid_pos := _find_random_spot(pc)
		pc.initialize(i, character, true, grid_pos[0], grid_pos[1])
		pc.position = player_grid_positions[grid_pos[0]][grid_pos[1]]
		pc.z_index = grid_pos[1] + 1
		pc.player_clicked.connect(_on_player_clicked)
		add_child(pc)
		i+=1
		
func _set_up_obstacles(num: int) -> void:
	var n := num
	while n != 0:
		var ob := obstacles_scene.instantiate()
		var grid_pos := _find_random_spot("rock")
		ob.instantiate(grid_pos[0], grid_pos[1])
		ob.position = player_grid_positions[grid_pos[0]][grid_pos[1]]
		ob.z_index = grid_pos[1] + 1
		add_child(ob)
		n -= 1
		
		
func _find_random_spot(node_name) -> Array:
	var check := true
	var row;
	var column
	while check:
		row = randi() % 5
		column = randi() % 3
		if player_grid_array[row][column] == null:
			player_grid_array[row][column] = node_name
			check = false
	return [row, column]
	

## Use the up arrow to cycle through the characters needs cooldown
func _reset_turn() -> void:
	for child in get_children():
		if child.has_method("_set_player_position"):
			child.moved = 0
			child.defense = 0

	
func _path_clear(hero) -> bool:
	var column := 0;
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
	
func _on_player_clicked(pos) -> void:
	# Find which player was clicked
	for child in get_children():
		if child.has_method("_set_player_position"):
			if child.player_position == pos && child.moved <= 0:
				selected_player = child
				child.toggle_hit_box()
				selected_player_pos = pos[0]
				_highlight_around_character(pos[0],pos[1], true)
				

###############
func _on_tile_clicked(row, column) -> void:
	if selected_player == null:
		return
	
	var context = MovementContext.new()
	context.actor = selected_player
	context.from_row = selected_player.player_position[0]
	context.from_col = selected_player.player_position[1]
	context.to_row = row
	context.to_col = column
	
	context.max_distance = 1
	
	_apply_movement_modifiers(context)
	
	if not context.is_valid(player_grid_array):
		return
	
	_execute_movement(context)
	
func _execute_movement(context: MovementContext) -> void:
	_highlight_around_character(context.from_row, context.from_col, false)
	
	player_grid_array[context.from_row][context.from_col] = null
	
	context.actor._set_player_position(context.to_row, context.to_col)
	context.actor.position = player_grid_positions[context.to_row][context.to_col]
	context.actor.z_index = context.to_row + 1
	
	player_grid_array[context.to_row][context.to_col] = context.actor

	context.actor.moved += 1
	context.actor.toggle_hit_box()
	selected_player = null
	
func _apply_movement_modifiers(context: MovementContext) -> void:
	# Example: if slowed
	if "slowed" in context.status_effects:
		context.max_distance = 0
	
	# Example: dash ability
	if "dash" in context.status_effects:
		context.max_distance = 2
	
	# Example: rooted
	if "rooted" in context.status_effects:
		context.action_blocked = true
##############

func _highlight_around_character(row, column, highlight):
	var current_row := []
	for vert in range(-1, 2):
		if (vert + row >= 0) and (vert + row <= player_grid_array.size() - 1):
			current_row = player_grid_array[row + vert]
			for hor in range(-1, 2):
				if (hor + column >= 0) and (hor + column <= current_row.size() - 1):
					if (current_row[column + hor] == null):
						if (highlight):
							grid[row+vert][column+hor]._highlight()
						else:
							grid[row+vert][column+hor]._un_highlight()
