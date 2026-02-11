@tool
extends Control
class_name CardBack

## Card data represented by this card
var _data : DeckPreset
## Exposed [member _data] to update vfx when changed
@export var data: DeckPreset:
	get: return _data
	set(val):
		_data = val
		_update_vfx()

## Rect that is colored to match card data TODO temporary until vfx assets provided
var _col_rect : ColorRect
## Exposed [member _col_rect] to update vfx when changed
@export var col_rect : ColorRect:
	get: return _col_rect
	set(val):
		_col_rect = val
		_update_vfx()

@export var force_update_vfx : bool:
	get: return false
	set(_val):
		_update_vfx()

## Updates the vfx with card color and card name
func _update_vfx() -> void:
	if _data == null: return
	if _col_rect == null: return
	
	_col_rect.color = _data.color