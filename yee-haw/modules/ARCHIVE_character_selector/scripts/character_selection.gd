@tool
extends Button

## Controls hero selection on the hero selection screen
class_name CharacterSelection

## Selection scene root to return data to
var _root : CharacterSelectionScene

## Character data represented by option
var _data : CharacterData
## Exposed [member _data] to update vfx when changed
@export var data : CharacterData:
	get: return _data
	set(val):
		_data = val
		_update_vfx()

## VFX to represent character TODO temporary until we get textures for heroes
var _col_rect : ColorRect
## Exposed [member _col_rect] to update vfx when changed
@export var col_rect : ColorRect:
	get: return _col_rect
	set(val):
		_col_rect = val
		_update_vfx()

## Label to display the character name
var _label : Label
## Exposed [member _label] to update vfx when changed
@export var label : Label:
	get: return _label
	set(val):
		_label = val
		_update_vfx()

## Editor variable that forces a VFX reload when clicked. Can be removed for project build
@export var reload : bool:
	get: return false
	set(_val): _update_vfx()

## Called by the [member _root] to set this selections scene reference
func set_selection_scene(ss: CharacterSelectionScene) -> void:
	_root = ss

func _ready() -> void:
	call_deferred("_update_vfx")

## Updates the VFX to match the character color and name on selection
func _update_vfx() -> void:
	if _col_rect == null: 
		return
	if _label == null: 
		return
	if _data == null: 
		return
	
	_col_rect.color = data.color
	_label.text = _data.name

## Called when the button is pressed to signal selection / deselection from roster
func _pressed() -> void:
	if _root == null:
		return
	
	_root.selection_bar.toggle_character(_data)