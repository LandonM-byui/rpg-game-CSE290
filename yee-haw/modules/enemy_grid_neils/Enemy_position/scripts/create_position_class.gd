extends Resource

class_name EnemyPosition
																													   

#Setting position as an integer
# DO NOT set above 15!
#@export var position: EnemyPosition

@export var position_value: int







#
#enum PositionKey{
	#ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT,
	#NINE, TEN, ELEVEN, TWELVE, THIRTEEN, FOURTEEN, FIFTEEN
#}
#@export var position_key : PositionKey



'''From Dallin, for setting the positions rather than an enum
'''

#{gdscript}
#func set_pos(p: Vector2i) -> bool:
  #out of bounds: return false
  #else:
	#curr_pos = p
  #return true
