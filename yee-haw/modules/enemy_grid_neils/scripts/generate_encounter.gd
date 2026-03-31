extends Node #may change later




@export var current_difficulty : EncounterDifficulty

@export var packed_node : PackedScene #The generic node for the enemy sprite!
@export var col_nodes : Array[ColumnSelectionArea]
@export var row_nodes : Array[RowSelectionArea]
#@export var test : int

'''
Nested to show the order they are called, will move them down when coding for ease of reading

main function
'''


var remaining_difficulty = preload("res://modules/enemy_grid_neils/difficulty/data(resources)/starting_difficulty.tres").difficulty



'''
Loading Presets below. Loading them manually via export and the inspector
Will later update to use DirAcess and load them automatically
'''

#++IF using enemy presets, that function will go HERE 
#	create list of enemy type presets

# Grabbing specifictally the list of resources the preset resources have as a variable
var approved_enemy_preset1 = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/everyone.tres").preset
var approved_enemy_preset2 = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/evens.tres").preset
var approved_enemy_preset3 = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/odds.tres").preset
var approved_enemy_preset4 = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/named.tres").preset
var approved_enemy_preset5 = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/not_so_lucky.tres").preset
#ETC.




var type_presets = [approved_enemy_preset1, approved_enemy_preset2, approved_enemy_preset3, 
approved_enemy_preset4, approved_enemy_preset5] #ETC


#@export var layout_presets : Array[EnemyLayoutPreset]
@export var presets : Array[EnemyLayoutPreset]

var layout
#creating list of layout presets
#@export var approved_layout_preset1 = preload("res://modules/enemy_grid_neils/layout/data/TEST_preset.tres").layout

#ETC


#var layout_presets = [approved_layout_preset1, approved_layout_preset2, approved_layout_preset3, 
	#approved_layout_preset4, approved_layout_preset5, approved_layout_preset6] #ETC


# How to get enemy difficulty rating?
#var difficulty = layout_preset[1].difficulty_rating


var enemy_position : Vector2

var enemy_grid_positions = [ # organized so positions[col][row] will be grid (x,y)
	# X Rows
	[Vector2(-300, -300),Vector2(-300, -150),Vector2(-300, 0),Vector2(-300, 150),Vector2(-300, 300),], # Y collums
	[Vector2(0, -300),Vector2(0, -150),Vector2(0, 0),Vector2(0, 150),Vector2(0, 300),],
	[Vector2(300, -300),Vector2(300, -150),Vector2(300, 0),Vector2(300, 150),Vector2(300, 300)]
]

# Will replace this with the chosen EnemyLayoutPreset.
var enemy_grid = [
	null,null,null,
	null,null,null,
	null,null,null,
	null,null,null,
	null,null,null
]

var num = 0


func pick_type_preset(type_presets):
	'''picks a random preset from list of available presets'''
	num = (randi_range(1,len(type_presets)) -1)
	var chosen_type_preset = type_presets[num]
	
	return chosen_type_preset


func pick_layout_preset(layout_presets):
	'''picks a random preset from list of available presets'''
	num = (randi_range(1,len(layout_presets)) -1)
	var chosen_layout_preset = layout_presets[num]
	
	return chosen_layout_preset

func pick_preset(presets):
	num = (randi_range(0,(len(presets)-1)))
	var chosen_preset = presets[num]
	print(chosen_preset)
	var layout : Array = [
	[chosen_preset.enemy0_position, chosen_preset.enemy3_position, chosen_preset.enemy6_position, chosen_preset.enemy9_position, chosen_preset.enemy12_position],
	[chosen_preset.enemy1_position, chosen_preset.enemy4_position, chosen_preset.enemy7_position, chosen_preset.enemy10_position, chosen_preset.enemy13_position],
	[chosen_preset.enemy2_position, chosen_preset.enemy5_position, chosen_preset.enemy8_position, chosen_preset.enemy11_position, chosen_preset.enemy14_position]
	]
	return layout
	
	
	
	
	
	
	
#func get_valid_positions(chosen_layout_preset,enemy_grid):
	#'''
	#parameters:
		#chosen_layout :resource
		#set enemy_grid e
		#'''
	#
	#var positions = 
#
	#for i in len()
			#if (row > 0) and (row <= 15):
				##row_num = row-1
				##collumn_num = collumn-1
				#enemy_grid[collumn][row] = positions[collumn][row]
			#else:
				#continue
#
	#return enemy_grid



func pick_enemy(chosen_type_preset):
	'''	take remaining_difficulty as a parameter
	'''
	num = (randi_range(1,len(chosen_type_preset)) -1)
	var chosen_enemy : Enemy = load(chosen_type_preset[num])
	return chosen_enemy



func make_enemy_grid(chosen_layout_preset, chosen_type_preset, remaining_difficulty):
	'''assigning a specific enemy to a place on the enemy layout

	Parameters: chosen_layout_preset, chosen_type_preset, remaining_difficulty
	
	'''
	while remaining_difficulty > 0:
		for i in chosen_layout_preset:
			var spot = chosen_layout_preset[i]
			if not spot:
				var chosen_enemy = pick_enemy(chosen_type_preset)
				print(chosen_enemy)
				# How to get enemy difficulty rating??????????
				var difficulty = chosen_enemy.difficulty_rating
				print(difficulty)
				remaining_difficulty = remaining_difficulty - difficulty
			else:
				continue
	return chosen_layout_preset


#func Big_loop(enemy_grid,remaining_difficulty):
	#'''for assigning enemies to the grid
	#'''
	#for collumn in enemy_grid:
		#for row in enemy_grid:
			#if row != null and remaining_difficulty > 0:
				#var enemy :Enemy = load(possible_enemies(remaining_difficulty))
				#
				#remaining_difficulty = remaining_difficulty - enemy.difficulty_rating
			#else:
				#continue




# TEST example for getting enemy info



	'''
	'I killed metro man, I did it'
	
	
	For each enemy variable, CREATE A POSITION VARIABLE
			add the position vector coordinants to each enemy when it is instantiated!
	'''
	
	
	
	
	'''
translate_enemy_positions
	will insert one part of the array as a parameter
	
	will then set a vector2 variable equal to the corresponding coordinants
'''
	
	'''Using copilot again for now because its 4am'''
func instantiate_enemies(chosen_preset: Array, enemy_grid_positions: Array, packed_node: PackedScene) -> void:
	var no = load("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
	# sanity checks
	if chosen_preset.size() != enemy_grid_positions.size():
		push_error("chosen_preset and enemy_grid_positions column count mismatch")
	for c_index in range(chosen_preset.size()):
		var col = chosen_preset[c_index]
		if not (col is Array):
			push_error("chosen_preset[%d] is not an Array" % c_index)
			continue
		for r_index in range(col.size()):
			var cell = col[r_index]
			# debug: print indices and value
			# print("checking cell [", c_index, ",", r_index, "]: ", cell)
			if cell == null:
				continue
			if cell.resource_path == no.resource_path:
				continue
			var position = enemy_grid_positions[c_index][r_index]
			instantiate_enemy(cell, position, packed_node,c_index,r_index)
	
	
	
	
#func instantiate_enemies(chosen_preset, enemy_grid_positions, packed_node) -> void:
		#
	#var no = load("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
	##var no_id = no.get_instance_id()
	#for c_index in range(chosen_preset.size()):
		#var col = chosen_preset[c_index]
		#for r_index in range(c_index):
			##var row_id = row.get_instance_id()
			#var enemy = chosen_preset[c_index][r_index]
			#if enemy != no:
			##if row_id != no_id:
				#var position = enemy_grid_positions[c_index][r_index]
				##enemy_grid_position[i]
				#instantiate_enemy(enemy,position,packed_node)
				#print(enemy)
				#print(position)
			#else:
				#continue




func instantiate_enemy(enemy,position,packed_node,c_index,r_index) -> void:
	'''both intantiates the enemy and assigns the sprite!'''
	var this_enemy = enemy#.instantiate()
	var node = packed_node.instantiate()
	node.enemy_data = this_enemy #making the resource accesible through the node!
	this_enemy.current_position = position #hopefully makes it easier to get the position later!
	node.position = position #+ Vector2(1000,1000)
	this_enemy.grid = [c_index,r_index]
	node.grid_column = c_index
	node.grid_row = r_index
	give_col_ref(c_index,node)
	give_row_ref(r_index,node)
	
	
	print(node.grid_column, node.grid_row)
	#node.position = Vector2(400,800) # temp fix
	#this_enemy.position = position
	
	
	set_enemy_node_sprite(this_enemy,node) #sets sprite!
	print()
	print(this_enemy)
	print(position)
	add_child(node)
	

	#add_child(node)
	#node.show()


func set_enemy_node_sprite(this_enemy,node) -> void:
	'''sets sprite! 
	AFTER MERGING: set get_node path to AnimatedSprite2D, AND Enemy.sprite_path to animation frames'''
	var sprite_node = node.get_node('lame_sprite') #change this to AnimatedSprite2D later!
	var new_path = this_enemy.sprite_path
	sprite_node.path = new_path
	#add_child(sprite_node)

	

func give_col_ref(col,node):
	col_nodes[col].node_ref = node.path
	


func give_row_ref(row,node):
	col_nodes[row].node_ref = node.path
	




func _ready():
	'''New plan, only enemy_layout_preset that will be preset encounters, pick randomly from those,
	not random layout and random type (from presets)'''
	
	var chosen_preset = pick_preset(presets)
	instantiate_enemies(chosen_preset, enemy_grid_positions, packed_node)
	
	

	
	
	'''Make random layout and enemies from presets if have time
	MAYBE create new preset resouce in code, for each spot, randomize the Enemy resource in each position,
	list of possible enemies different for each difficulty
		no enemy weighted high so that most spots will be empty (at first)
	'''
	
		#var chosen_type_preset = pick_type_preset(type_presets)
	#var chosen_layout_preset = pick_layout_preset(layout_presets)
	#
	#make_enemy_grid(chosen_layout_preset, chosen_type_preset, remaining_difficulty)
	#instantiate_enemies(chosen_layout_preset, enemy_grid_positions)
	
