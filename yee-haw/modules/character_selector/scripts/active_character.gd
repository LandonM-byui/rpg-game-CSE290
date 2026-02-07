extends Resource

## Defines data for a currently active in-game character
class_name ActiveCharacter

## Base character data
var data : CharacterData
## Current character health
var health : int
## Current character status' and their count
var status : Dictionary[CharacterStatus, int]