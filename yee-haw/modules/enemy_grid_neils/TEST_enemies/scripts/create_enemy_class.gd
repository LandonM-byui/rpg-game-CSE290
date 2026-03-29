extends Resource

class_name Enemy

# using an enum so that the enemy type is more easily checked?
#@export var enemy_name : String

@export var max_health : int
var health : int
@export var attack : int
@export var difficulty_rating : int

# test to see if it is easier to set each position to a flag (enemy type)




@export var enemy_name = EnemyName.NO
'''When creating a new enemy type, add the name in all caps to the enum EnemyName!
'''
enum EnemyName {
	YES,
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX,
	LUCKY,
	ELLEN,
	NO
}

@export var sprite_path = "res://Assets/Sample Assets/Rectangle.jpg"
@export var current_position : Vector2 = Vector2(0,0)
@export var grid = []
