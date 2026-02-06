@tool
extends Control
class_name Card

var mouse_hover : bool = false
const HOVER_OFFSET : float = 80.0
var grabbed : bool = false
var grab_offset : Vector2

var target_position_global : Vector2 = Vector2.ZERO
var target_rotation : float = 0.0
var target_vfx_y : float = 0.0

const SMOOTHING : float = 0.18

var _data : CardData
@export var data: CardData:
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

@export var vfx_container : Control

func _update_vfx() -> void:
	if _data == null: return
	if _col_rect == null: return
	if _label == null: return
	
	_col_rect.color = _data.color
	_label.text = _data.name

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		mouse_hover = false
		_hover_update_vfx()
		return
	
	_hover_update_vfx()
	
	if grabbed:
		mouse_filter = MOUSE_FILTER_IGNORE
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			grabbed = false
	if not grabbed:
		mouse_filter = MOUSE_FILTER_STOP
	_update_placement()
	
	_attack_card_intersection()

func _hover_update_vfx() -> void:
	if vfx_container == null:
		return

	if mouse_hover:
		target_vfx_y = -HOVER_OFFSET
	else:
		target_vfx_y = 0
	
	vfx_container.position.y = lerp(vfx_container.position.y, target_vfx_y, SMOOTHING)

func _update_placement() -> void:
	if grabbed:
		target_position_global = get_global_mouse_position() + grab_offset
		var x_diff := global_position.x - target_position_global.x
		var scaled_diff := x_diff / 400
		var clamped_diff : float = min(1.0, max(-1.0, scaled_diff))
		target_rotation = deg_to_rad(clamped_diff * 25.0)

	global_position = lerp(global_position, target_position_global, SMOOTHING)
	rotation = lerp(rotation, target_rotation, SMOOTHING)

func _on_mouse_exited():
	mouse_hover = false

func _on_mouse_entered():
	mouse_hover = true


func _on_gui_input(event: InputEvent):
	if not mouse_hover: return
	if not event is InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	
	if event.is_pressed():
		grabbed = true
		grab_offset = global_position - get_global_mouse_position()
		
		return true
	
	if event.is_released():
		grabbed = false

var last_selected : EnemySelectionArea = null
func _attack_card_intersection() -> void:
	if not grabbed: 
		_clear_selection()
		return
	
	if not _data is AttackCard:
		_clear_selection()
		return
	
	var _hit := _get_mouse_cast()
	if _hit.size() == 0:
		_clear_selection()
		return
	
	if not _hit["collider"] is EnemySelectionArea:
		_clear_selection()
		return
	
	var esa := _hit["collider"] as EnemySelectionArea
	if esa == last_selected: return
	
	_clear_selection()
	esa.select()
	last_selected = esa
	
func _get_mouse_cast() -> Dictionary:
	var mouse_pos := get_global_mouse_position()
	var space_state := get_world_2d().direct_space_state

	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collision_mask = (_data as AttackCard).get_selection_layer()
	query.collide_with_bodies = true
	query.collide_with_areas = true
	
	# get intersection right under the mouse
	var result := space_state.intersect_point(query, 1)
	
	if result.size() > 0:
		return result.front()
	return {}

func _clear_selection() -> void:
	if last_selected == null:
		return
	last_selected.deselect()
	last_selected = null