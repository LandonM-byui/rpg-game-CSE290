extends Node2D


var enemy_grid_positions = [
	[Vector2(-300, -600), Vector2(0, -600), Vector2(300, -600)],
	[Vector2(-300, -300), Vector2(0, -300), Vector2(300, -300)],
	 [Vector2(-300, 0), Vector2(0, 0), Vector2(300, 0)],
	 [Vector2(-300, 300), Vector2(0, 300), Vector2(300, 300)],
	 [Vector2(-300, 600), Vector2(0, 600), Vector2(300, 600)]
	]



# Vecor2i #integer vector

var enemy_position : Vector2
var: slot

func _onready():
	translate_enemy_positions(enemy_grid_positions)


#
#func translate_enemy_positions(enemy_grid_positions):
	#if EnemyPosition.PositionKey.ONE:
		#enemy_position = enemy_grid_positions[0][0]
		#print('position: 1,1')
		#
	#elif EnemyPosition.PositionKey.TWO:
		#enemy_position = enemy_grid_positions[0][1]
		#print('position: 1,2')
		#
	#elif EnemyPosition.PositionKey.THREE:
		#enemy_position = enemy_grid_positions[0][2]
		#print('position: 1,3')
		#
	#elif EnemyPosition.PositionKey.FOUR:
		#enemy_position = enemy_grid_positions[1][0]
		#print('position: 2,1')
		#
	#elif EnemyPosition.PositionKey.FIVE:
		#enemy_position = enemy_grid_positions[1][1]
		#print('position: 2,2')
		#
	#elif EnemyPosition.PositionKey.SIX:
		#enemy_position = enemy_grid_positions[1][2]
		#print('position: 2,3')
		#
	#elif EnemyPosition.PositionKey.SEVEN:
		#enemy_position = enemy_grid_positions[2][0]
		#print('position: 3,1')
		#
	#elif EnemyPosition.PositionKey.EIGHT:
		#enemy_position = enemy_grid_positions[2][1]
		#print('position: 3,2')
		#
	#elif EnemyPosition.PositionKey.NINE:
		#enemy_position = enemy_grid_positions[2][2]
		#print('position: 3,3')
		#
	#elif EnemyPosition.PositionKey.TEN:
		#enemy_position = enemy_grid_positions[3][0]
		#print('position: 4,1')
		#
	#elif EnemyPosition.PositionKey.ELEVEN:
		#enemy_position = enemy_grid_positions[3][1]
		#print('position: 4,2')
		#
	#elif EnemyPosition.PositionKey.TWELVE:
		#enemy_position = enemy_grid_positions[3][2]
		#print('position: 4,3')
		#
	#elif EnemyPosition.PositionKey.THIRTEEN:
		#enemy_position = enemy_grid_positions[4][0]
		#print('position: 5,1')
		#
	#elif EnemyPosition.PositionKey.FOURTEEN:
		#enemy_position = enemy_grid_positions[4][1]
		#print('position: 5,2')
		#
	#elif EnemyPosition.PositionKey.FIFTEEN:
		#enemy_position = enemy_grid_positions[4][2]
		#print('position: 5,3')
		#
