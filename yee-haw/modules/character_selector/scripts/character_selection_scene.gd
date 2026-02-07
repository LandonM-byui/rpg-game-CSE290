extends Control

## Handles the entire scene for character selection into party
class_name CharacterSelectionScene

## UI bar that displays all selected heroes
@export var selection_bar : SelectedCharacterBar
## Container where all [CharacterSelection] nodes are contained
@export var selection_options_container : Control

func _ready() -> void:
	# sets self reference for all CharacterSelections in container
	for child in selection_options_container.get_children():
		if not child is CharacterSelection:
			continue
		
		var sel := child as CharacterSelection
		sel.set_selection_scene(self) 