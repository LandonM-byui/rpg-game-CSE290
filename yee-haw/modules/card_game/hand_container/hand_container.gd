extends Control
class_name HandContainer

const MAX_TOTAL_ANGLE : float = 20.0
const DEFAULT_ANGLE : float = 3.5

var _child_selected : bool
var _selected_child : Control

signal update_positions(selected_index: int, angles: float, start_angle: float, skip_selected: bool)

func clear_hand_vfx() -> void:
	for child in %CARD_CONTAINER.get_children():
		child.queue_free()
	
	_child_selected = false
	_selected_child = null

func add_to_hand(hand: Array[IndexedCard]) -> void:
	for ic in hand:
		_add_card(ic)

func _add_card(card: IndexedCard):
	var c := preload("uid://bukkanr4pda5r").instantiate() as Card
	c.connect_data(card)
	c.connect_selection_dependence(_can_select, _update_selection)
	c.connect_pivot_positioning(%PIVOT, update_positions, _call_position_update)
	%CARD_CONTAINER.add_child(c)
	c.owner = %CARD_CONTAINER.owner
	c.position.x = c.get_index()
	
	_call_position_update()
		
func _update_selection(child: Control, select: bool) -> void:
	if select:
		_select_child(child)
	else:
		_deselect_child(child)
	_call_position_update()

func _select_child(child: Control) -> void:
	_child_selected = true
	_selected_child = child

func _deselect_child(child: Control) -> void:
	if not child == _selected_child: return
	_child_selected = false
	_selected_child = null

## Returns true if the indexed child is allowed to show hover vfx
func _can_select(child: Control) -> bool:
	if _child_selected and _selected_child != child:
		return false
	
	return true

func _call_position_update() -> void:
	var selected_index : int
	if not _child_selected: selected_index = -1
	else: selected_index = _selected_child.get_index()
	
	var skip_selected:= \
		get_global_mouse_position().y - global_position.y < -1000 and \
		_child_selected
	
	var active_cards := %CARD_CONTAINER.get_child_count()
	
	if skip_selected: active_cards -= 1
	
	var total_angle : float = min(MAX_TOTAL_ANGLE, DEFAULT_ANGLE * (active_cards - 1))
	var indiv_angle := deg_to_rad(total_angle / (active_cards - 1))
	var start_angle := deg_to_rad((total_angle * -0.5) - 90)
	
	
	update_positions.emit(selected_index, indiv_angle, start_angle, skip_selected)
