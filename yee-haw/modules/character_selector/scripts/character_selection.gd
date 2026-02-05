@tool
extends Button
class_name CharacterSelection

var _root : CharacterSelectionScene

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
var _label : Label
@export var label : Label:
	get: return _label
	set(val):
		_label = val
		_update_vfx()

@export var reload : bool:
	get: return false
	set(_val): _update_vfx()
	
func set_selection_scene(ss: CharacterSelectionScene) -> void:
	_root = ss

func _ready() -> void:
	call_deferred("_update_vfx")

func _update_vfx() -> void:
	if _col_rect == null: 
		return
	if _label == null: 
		return
	if _data == null: 
		return
	
	_col_rect.color = data.color
	_label.text = _data.name

func _pressed() -> void:
	if _root == null:
		return
	
	_root.selection_bar.toggle_character(_data)