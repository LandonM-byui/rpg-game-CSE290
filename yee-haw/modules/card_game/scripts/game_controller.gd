extends Node

## Source and control of all game logic. Acts as a delegator to sub-systems to manage and alter the game state, and 
## passes signals between systems.
class_name GameController

## TODO will need to get preset by scene from passed data from setup, such as roster, deck chosen (?), and other to initialize the deck 
## All tracked game data
var data : GameData

## Sets up the initial game state
func set_up_game(roster: Array[CharacterData], deck_preset: DeckPreset) -> void:
	data = GameData.CreatePreset(roster, deck_preset)

func _update_ui() -> void:
	# if no discards hide discard
	# if no deck, hide deck
	
	# set focus of game (when in sub-menus)
	
	pass