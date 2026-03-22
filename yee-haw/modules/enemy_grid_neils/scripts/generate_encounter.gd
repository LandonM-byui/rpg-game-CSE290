extends Node #may change later




@export var current_difficulty : EncounterDifficulty


'''
Nested to show the order they are called, will move them down when coding for ease of reading

main function
'''


var remaining_difficulty : EncounterDifficulty = preload("res://modules/enemy_grid_neils/difficulty/data(resources)/starting_difficulty.tres")



'''
Loading Presets below. Loading them manually via export and the inspector
Will later update to use DirAcess and load them automatically
'''

#++IF using enemy presets, that function will go HERE 
#	create list of enemy type presets

# Grabbing specifictally the list of resources the preset resources have as a variable
var approved_enemy_preset1 : EnemyTypePreset = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/everyone.tres").preset
var approved_enemy_preset2 : EnemyTypePreset  = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/evens.tres").preset
var approved_enemy_preset3 : EnemyTypePreset  = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/odds.tres").preset
var approved_enemy_preset4 : EnemyTypePreset  = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/named.tres").preset
var approved_enemy_preset5 : EnemyTypePreset = preload("res://modules/enemy_grid_neils/enemy_type_preset/data/not_so_lucky.tres").preset
#ETC.




var type_presets = [approved_enemy_preset1, approved_enemy_preset2, approved_enemy_preset3, 
approved_enemy_preset4, approved_enemy_preset5] #ETC


#creating list of layout presets
@export var approved_layout_preset1 : EnemyLayoutPreset = preload("res://modules/enemy_grid_neils/layout/data/TEST_preset.tres").layout
@export var approved_layout_preset2 : EnemyLayoutPreset = preload("res://modules/enemy_grid_neils/layout/data/bottom_row.tres").layout
@export var approved_layout_preset3 : EnemyLayoutPreset = preload("res://modules/enemy_grid_neils/layout/data/front_collumn.tres").layout
@export var approved_layout_preset4 : EnemyLayoutPreset = preload("res://modules/enemy_grid_neils/layout/data/odds.tres").layout
@export var approved_layout_preset5 : EnemyLayoutPreset = preload("res://modules/enemy_grid_neils/layout/data/six2eleven.tres").layout
@export var approved_layout_preset6 : EnemyLayoutPreset = preload("res://modules/enemy_grid_neils/layout/data/zero2five.tres").layout
#ETC


var layout_presets = [approved_layout_preset1, approved_layout_preset2, approved_layout_preset3, 
	approved_layout_preset4, approved_layout_preset5, approved_layout_preset6] #ETC


# How to get enemy difficulty rating?
#var difficulty = layout_preset[1].difficulty_rating


var enemy_position : Vector2

var enemy_grid_positions = [
	Vector2(-300, -600), Vector2(0, -600), Vector2(300, -600),
	Vector2(-300, -300), Vector2(0, -300), Vector2(300, -300),
	 Vector2(-300, 0), Vector2(0, 0), Vector2(300, 0),
	 Vector2(-300, 300), Vector2(0, 300), Vector2(300, 300),
	 Vector2(-300, 600), Vector2(0, 600), Vector2(300, 600)
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
			if not chosen_layout_preset[i]:
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
	
	
func instantiate_enemies(chosen_layout_preset, enemy_grid_positions):
	'''
	Parameters:
	current positions
	position coordinants
	list of possible enemies OR enemy preset
	
	will pick random enemy from possible_enemies OR enemy preset
	set enemy at specific grid positions to chosen enemy
	
	instantiate enemy scenes 
	parallel lists of vectors and grid(to track if it has something)
	'''
		
		
	''' Using method from the Dodge the Creeps tutorial as reference
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position
	'''
		
		
	for i in chosen_layout_preset:
		chosen_layout_preset[i]
		var position = enemy_grid_positions[i]
	
	
	
	
