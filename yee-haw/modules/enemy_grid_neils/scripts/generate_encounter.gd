extends Node
class_name EnemyGridController

@export var current_difficulty : EncounterDifficulty

@export var packed_node : PackedScene
@export var col_nodes : Array[ColumnSelectionArea]
@export var row_nodes : Array[RowSelectionArea]

var remaining_difficulty = preload("res://modules/enemy_grid_neils/difficulty/data(resources)/starting_difficulty.tres").difficulty

var approved_enemy_preset1 = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/everyone.tres").preset
var approved_enemy_preset2 = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/evens.tres").preset
var approved_enemy_preset3 = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/odds.tres").preset
var approved_enemy_preset4 = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/named.tres").preset
var approved_enemy_preset5 = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/not_so_lucky.tres").preset

var type_presets : Array = [approved_enemy_preset1, approved_enemy_preset2, approved_enemy_preset3, 
approved_enemy_preset4, approved_enemy_preset5]

@export var presets : Array[EnemyLayoutPreset]

var layout

var enemy_position : Vector2

var enemy_grid_positions : Array = [
	[Vector2(-300, -300),Vector2(-300, -150),Vector2(-300, 0),Vector2(-300, 150),Vector2(-300, 300),],
	[Vector2(0, -300),Vector2(0, -150),Vector2(0, 0),Vector2(0, 150),Vector2(0, 300),],
	[Vector2(300, -300),Vector2(300, -150),Vector2(300, 0),Vector2(300, 150),Vector2(300, 300)]
]

var enemy_grid : Array

var current_enemies : Array

var num := 0


var attack_queue : Array = [
	[0],
	[0],
	[0],
	[0],
	[0]
]



func queue_attacks() -> void:
	#turn_signal = _______.connect()
	
	for r in current_enemies:
		for c in r:
			c.enemy_attack()
	




''' some functions below are legacy, and unused in order to simplify the game for completion for the expo.
		I am leaving them here for proof of work done!
		
	A few functions below, particuarly at the bottom are still very much used!
		'''
func pick_type_preset():
	num = (randi_range(1,len(type_presets)) -1)
	var chosen_type_preset = type_presets[num]
	
	return chosen_type_preset


func pick_layout_preset(layout_presets):
	num = (randi_range(1,len(layout_presets)) -1)
	var chosen_layout_preset = layout_presets[num]
	
	return chosen_layout_preset

func pick_preset() -> Array:
	num = (randi_range(0,(len(presets) - 1)))
	var chosen_preset := presets[num]
	var l := [
		[chosen_preset.enemy0_position, chosen_preset.enemy3_position, chosen_preset.enemy6_position, chosen_preset.enemy9_position, chosen_preset.enemy12_position],
		[chosen_preset.enemy1_position, chosen_preset.enemy4_position, chosen_preset.enemy7_position, chosen_preset.enemy10_position, chosen_preset.enemy13_position],
		[chosen_preset.enemy2_position, chosen_preset.enemy5_position, chosen_preset.enemy8_position, chosen_preset.enemy11_position, chosen_preset.enemy14_position]
	]
	return l


func pick_enemy(chosen_type_preset):
	num = (randi_range(1,len(chosen_type_preset)) -1)
	var chosen_enemy : Enemy = load(chosen_type_preset[num])
	return chosen_enemy



func make_enemy_grid(chosen_layout_preset, chosen_type_preset):
	while remaining_difficulty > 0:
		for i in chosen_layout_preset:
			var spot = chosen_layout_preset[i]
			if not spot:
				var chosen_enemy = pick_enemy(chosen_type_preset)
				var difficulty = chosen_enemy.difficulty_rating
				remaining_difficulty = remaining_difficulty - difficulty
			else:
				continue
	return chosen_layout_preset


func instantiate_enemies(chosen_preset: Array) -> void:
	current_enemies = []
	for _r in range(5): current_enemies.append([null, null, null])
	
	print(current_enemies)
	
	var no = load("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
	if chosen_preset.size() != enemy_grid_positions.size():
		push_error("chosen_preset and enemy_grid_positions column count mismatch")
	for c_index in range(chosen_preset.size()):
		var col = chosen_preset[c_index]
		if not (col is Array):
			push_error("chosen_preset[%d] is not an Array" % c_index)
			continue
		for r_index in range(col.size()):
			var cell = col[r_index]
			if cell == null:
				continue
			if cell.resource_path == no.resource_path:
				continue
			var position = enemy_grid_positions[c_index][r_index]
			instantiate_enemy(cell, position,c_index,r_index)


func instantiate_enemy(enemy,position,c_index,r_index) -> void:
	var this_enemy = enemy
	var node : EnemyController = packed_node.instantiate()
	node.enemy_data = this_enemy
	this_enemy.current_position = position
	node.position = position
	this_enemy.grid = [c_index,r_index]
	node.grid_column = c_index
	node.grid_row = r_index
	give_col_ref(c_index,node)
	give_row_ref(r_index,node)
	
	set_enemy_node_sprite(this_enemy,node)
	add_child(node)
	
	current_enemies[r_index][c_index] = (node as EnemyController)
	node.remove = func(): _nullify(r_index, c_index)
	node.full_heal()

func _nullify(x: int, y: int):
	current_enemies[x][y] = null	

func set_enemy_node_sprite(this_enemy,node) -> void:
	var sprite_node = node.get_node('lame_sprite')
	var new_path = this_enemy.sprite_path
	sprite_node.path = new_path
	

func give_col_ref(col,en: EnemyController):
	col_nodes[col].add_reference(en)
	en.col_ref = col_nodes[col]
	

func give_row_ref(row,en: EnemyController):
	row_nodes[row].add_reference(en)
	en.row_ref = row_nodes[row]
	

func _ready():
	var chosen_preset := pick_preset()
	instantiate_enemies(chosen_preset)
	
func get_enemy_count() -> int:
	var count := 0
	for r in current_enemies:
		for c in r:
			if not c == null: count += 1
	return count
