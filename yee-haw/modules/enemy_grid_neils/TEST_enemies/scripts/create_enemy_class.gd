extends Resource

class_name Enemy

# using an enum so that the enemy type is more easily checked?
#@export var enemy_name : String

@export var health : int
@export var attack : int
@export var difficulty_rating : int

# test to see if it is easier to set each position to a flag (enemy type)




@export var enemy_name = EnemyName.ONE
'''When creating a new enemy type, add the name in all caps to the enum EnemyName!
'''
enum EnemyName {
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX,
	LUCKY,
	ELLEN
}
