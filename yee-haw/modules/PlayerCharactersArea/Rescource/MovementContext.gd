extends Resource
class_name MovementContext

## Block movement entirely
var action_blocked: bool = false

## Who is moving
var actor = null

## Start position
var from_row: int
var from_col: int

## Target position
var to_row: int
var to_col: int

## How far the unit can move
var max_distance: int = 1

## Whether movement ignores obstacles
var ignore_obstacles: bool = false

## Flags (like AttackContext)
enum Flag {
	FreeMove,
	FirstMove,
}
var status_effects: Array[String] = []

var flags: Array[Flag] = []

func distance() -> Array:
	return [abs(from_row - to_row), abs(from_col - to_col)]

func is_valid(grid) -> bool:
	if action_blocked:
		return false
	
	# Check distance
	if distance()[0] > max_distance or distance()[1] > max_distance:
		return false
	
	
	# Check occupancy
	if not ignore_obstacles and grid[to_row][to_col] != null:
		return false
	
	return true
