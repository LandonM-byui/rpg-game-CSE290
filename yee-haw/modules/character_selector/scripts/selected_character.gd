@tool
extends Control
class_name SelectedCharacter

var _data : CharacterData
@export var data : CharacterData:
	get: return _data
	set(val):
		_data = val
		_update_vfx()

var _col_rect : ColorRect
@export var col_rect : ColorRect:
	get: return _col_rect
	set(val):
		_col_rect = val
		_update_vfx()

@export var reload : bool:
	get: return false
	set(_val): _update_vfx()
	
func _update_vfx() -> void:
	if _data == null: return
	if _col_rect == null: return
	
	_col_rect.color = data.color