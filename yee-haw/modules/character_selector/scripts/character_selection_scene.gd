extends Control
class_name CharacterSelectionScene

@export var selection_bar : SelectedCharacterBar
@export var selection_options_container : Control

func _ready() -> void:
	for child in selection_options_container.get_children():
		if not child is CharacterSelection:
			continue
		
		var sel = child as CharacterSelection
		sel.set_selection_scene(self) 