extends HBoxContainer
class_name SelectedCharacterBar

var _selected_characters : Dictionary = Dictionary()

@onready var _prefab : PackedScene = preload("uid://pwictcptp76f")
const MAX_CHARACTER_COUNT : int = 3

func toggle_character(c: CharacterData) -> void:
	if c.name in _selected_characters:
		_remove_character(c)
	else:
		_add_character(c)

func _remove_character(c: CharacterData) -> void:
	_selected_characters[c.name].queue_free()
	_selected_characters.erase(c.name)

func _add_character(c: CharacterData) -> void:
	if len(_selected_characters) >= MAX_CHARACTER_COUNT:
		return
	
	var new_selection := _prefab.instantiate() as SelectedCharacter
	new_selection.data = c
	
	add_child(new_selection)
	var second_to_last_idx : int = get_child_count() - 2
	move_child(new_selection, second_to_last_idx)
	new_selection.owner = owner
	_selected_characters[c.name] = new_selection
