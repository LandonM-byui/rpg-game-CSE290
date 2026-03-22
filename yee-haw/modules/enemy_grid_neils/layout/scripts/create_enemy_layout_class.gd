extends Resource

class_name EnemyLayoutPreset
# Zero is one of the viable positions, so it cananot be the default value

@export var enemy0_position : bool
@export var enemy1_position : bool
@export var enemy2_position : bool
@export var enemy3_position : bool
@export var enemy4_position : bool
@export var enemy5_position : bool
@export var enemy6_position : bool
@export var enemy7_position : bool
@export var enemy8_position: bool
@export var enemy9_position: bool
@export var enemy10_position : bool
@export var enemy11_position : bool
@export var enemy12_position : bool
@export var enemy13_position : bool
@export var enemy14_position : bool




'''
Key for enemy position labels
[ 0] [ 1] [ 2]
[ 3] [ 4] [ 5]
[ 6] [ 7] [ 8]
[ 9] [10] [11]
[12] [13] [14]
'''



@export var layout : Array = [
	enemy0_position,  enemy1_position,   enemy2_position,
	enemy3_position,  enemy4_position,   enemy5_position,
	enemy6_position,  enemy7_position,   enemy8_position,
	enemy8_position,  enemy9_position,  enemy11_position,
	enemy12_position, enemy13_position, enemy14_position
]
