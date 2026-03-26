extends Resource

class_name EnemyLayoutPreset
# Zero is one of the viable positions, so it cananot be the default value

@export var enemy0_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy1_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy2_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy3_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy4_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy5_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy6_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy7_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy8_position: Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy9_position: Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy10_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy11_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy12_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy13_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")
@export var enemy14_position : Enemy = preload("res://modules/enemy_grid_neils/TEST_enemies/data/NO.tres")


'''
Key for enemy position labels
[ 0] [ 1] [ 2]
[ 3] [ 4] [ 5]
[ 6] [ 7] [ 8]
[ 9] [10] [11]
[12] [13] [14]
'''


# organized so positions[col][row] will be grid (x,y)
@export var layout : Array = [
	[enemy0_position, enemy3_position, enemy6_position, enemy9_position, enemy12_position],
	[enemy1_position, enemy4_position, enemy7_position, enemy10_position, enemy13_position],
	[enemy2_position, enemy5_position, enemy8_position, enemy11_position, enemy14_position]
	]
