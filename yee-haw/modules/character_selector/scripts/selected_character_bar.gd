extends HBoxContainer

## Controls the UI Bar that contains the selected chracter roster
class_name SelectedCharacterBar

## All currently selected characters in-roster. Tracks by names referencing the [SelectedCharacter] node.
var _selected_characters : Dictionary[String, SelectedCharacter] = Dictionary()

## Scene prefab type [SelectedCharacter] that are created when characters are added to the bar
@onready var _prefab : PackedScene = preload("uid://pwictcptp76f")

## Maximum party size
const MAX_CHARACTER_COUNT : int = 3

## Toggles a character as selected/deselected. Prevents double-selection
## [br] When selected already, remove the hero from the party
## [br] When not selected, adds the hero to the party
func toggle_character(c: CharacterData) -> void:
	if c.name in _selected_characters:
		_remove_character(c)
	else:
		_add_character(c)

## Removes the character from the party
func _remove_character(c: CharacterData) -> void:
	_selected_characters[c.name].queue_free()
	_selected_characters.erase(c.name)

## Adds a character to the party
func _add_character(c: CharacterData) -> void:
	# can't add if party is already at max size
	if len(_selected_characters) >= MAX_CHARACTER_COUNT:
		return
	
	# create new selection node
	var new_selection := _prefab.instantiate() as SelectedCharacter
	# set data
	new_selection.data = c
	
	# parents the node into scene
	add_child(new_selection)
	var second_to_last_idx : int = get_child_count() - 2
	move_child(new_selection, second_to_last_idx)
	new_selection.owner = owner
	
	# store data reference
	_selected_characters[c.name] = new_selection
