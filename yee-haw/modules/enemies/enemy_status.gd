extends Resource

## Defines a named condition that can be applied to an enemy
class_name EnemyStatus

## Defines how this status reacts at the end of the turn
enum TurnEndBehaviour {
	Decrement,	## Reduces the count of this status by 1
	Remove,		## Completely removes the status
	Keep		## Status if kept and unchanged
}

## Name of the status
@export var name : String