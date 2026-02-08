extends Resource

## Defines data for a currently active in-game character
class_name ActiveCharacter

## Base character data
var data : CharacterData
## Current character health
var health : int
## Current character status' and their count
var status : Dictionary[CharacterStatus, int]

## Creates a new hero [param hero] as an [ActiveCharacter]
## [br][param hero]: Hero base data
static func Create(hero: CharacterData) -> ActiveCharacter:
	var ac := ActiveCharacter.new()
	
	ac.data = hero
	
	ac.health = hero.max_health
	
	# start with no status'
	# can possibly add a field to CharacterData that allows starting status?
	ac.status = {}
	
	return ac
	