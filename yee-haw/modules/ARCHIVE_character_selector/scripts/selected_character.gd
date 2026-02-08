@tool
extends Control

## Node control for a selected character in the [SelectedCharacterBar]
class_name SelectedCharacter

## Base character data representing the selected character
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

## Forces vfx reload in-editor, can be removed for production
@export var reload : bool:
	get: return false
	set(_val): _update_vfx()

## Updates the vfx to match the character color
func _update_vfx() -> void:
	# only updates VFX when all requirements have been set
	# avoid null reference errors
	if _data == null: return
	if _col_rect == null: return
	
	_col_rect.color = data.color