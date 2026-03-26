extends Resource



#@export var array: enemy_presets

enum preset{OSTERFISH, GOOBY}


enum difficulty{ONE, TWO, THREE, BOSS}
# Remake this as a resource! (Enums should be flags)


var current_difficulty


# IMPORTANT
'''From the top down, it will go 
#(current plan): pick_layout > get_difficulty > get_enemy_options(difficulty) > pick_enemies(enemy_options) > grid_assignment(layout,enemy_options)
OR
get_difficulty > get_enemy_options(difficulty) > pick_enemies(enemy_options) > pick_layout(enemies #use number of them#) > grid_assignment(layout,enemies)    
'''


func pick_layout():
	'''Will pick randomly from options of layouts, as resources?
	'''


func get_difficulty():
	'''Will get the difficulty of the level from where it is stored and pass as variable
	'''
	#current_difficulty = #however this function will get the data



'''ALTERNATIVELY:
	Instead of get_enemy_options and pick_enemies:
	Make a function that gets premade layouts of the current difficulty!
		pick_enemy_preset
'''
func get_enemy_options():
	'''WIll pick enemy types that are the same difficulty or less than current_difficulty
	'''
	#Using enum of difficulty assigned to each enemy, make array/list of options:
		#using each enemy resource
func pick_enemies(enemy_options):
	'''Will randomly / pick a layout that 
	'''
	





func grid_assignment(layout,enemy_options):
	'''
	'''









#
#
#func choose_enemy_preset(difficulty):
	#
	## +/- current difficulty?
#
#
#func choose_layout_preset(enemypreset):
	#
