extends Control

## A UI card node that reacts to mouse actions. Must be a child of a [CardSelectionController] to be interactive.
class_name Card


# -----------------------------------------------------
# Variables
# -----------------------------------------------------

# CONSTANTS
## How many extra degrees to pivot away from the selected card
const SELECTED_SEPERATION : float = 2.0
## How far the VFX are offset on mouse hover
const HOVER_OFFSET : float = 80.0
## Distance required to rotate [member MAX_VFX_ROTATION]
const MAX_VFX_ROTATION_DISTANCE : float = 400
## Max rotation (degrees) at [member MAX_VFX_ROTATION_DISTANCE]
const MAX_VFX_ROTATION : float = 30.0

## Card data
@export var _data : IndexedCard

var indexed_card : IndexedCard:
	get: return _data

# STATE TRACKING
## True when the mouse is hovering
var _hovering: bool = false
## True when the card is being dragged by the mouse
var _dragging: bool = false
## Drag offset from first mouse click to maintain drag location
var _drag_offset: Vector2
## Root position of the card on _ready
var _root_position: Vector2
## Current target postion
var target_position : Vector2

## UNIQUE TWEENS
## Current position/rotation tween on card
var _tween: Tween
## Current tween on the vfx
var _vfx_tween: Tween


# -----------------------------------------------------
# Adaptors
# -----------------------------------------------------

## Positioning pivot point
var _pivot : Control
## When called forces position updates on all cards in container
var _call_position_update : Callable

## Initializes the card into a container ([HandContainer]).
func connect_pivot_positioning( \
## Pivot point to position card
pivot: Control, \
## Starting angle off the pivot
update_position: Signal, \
## When called forces position updates on all cards in container
call_position_update: Callable \
) -> void:
	_pivot = pivot
	_call_position_update = call_position_update
	
	# connect to signal to update position
	update_position.connect(_update_position)
	# disconnect signal to update position when being destroyed/freed
	child_exiting_tree.connect(func(_v): update_position.disconnect(_update_position))

## Connects override data to the card
func connect_data( \
## Base card data
data: IndexedCard, \
) -> void:
	_data = data
	_update_vfx()

## Callback to check if the card can be interacted with
var _can_select : Callable
## Updates the controller with the card's selection status
var _change_selection: Callable

## Connects selection dependency to container. Container will limit concurrent selections.
func connect_selection_dependence( \
## Callable to check if card is selectable
can_select: Callable, \
## Callback to update selection status
change_selection: Callable \
) -> void:
	_can_select = can_select
	_change_selection = change_selection

# -----------------------------------------------------
# Internal
# -----------------------------------------------------

func _update_selection() -> void:
	if _change_selection:
		_change_selection.call(self, _hovering or _dragging)

## Updates the vfx with card color and card name
func _update_vfx() -> void:
	if _data == null: 
		%CardVfx.initialize("<none>", Color(1, 1, 1, 1))
		return
	%CardVfx.initialize(_data.data.color, _data.data.name)
	
func _ready() -> void:
	_update_vfx()
	
	_root_position = global_position

	mouse_entered.connect(func(): _card_hover(true))
	mouse_exited.connect(func(): _card_hover(false))
	
	_card_hover(false)

## Handles tweening the vfx position to show a card hover/not.
func _card_hover(is_hovering: bool) -> void:
	if _can_select:
		if is_hovering and not _can_select.call(self):
			return
	
	_hovering = is_hovering
	if _dragging: return
	
	var offset := 0.0
	if _hovering: offset = -HOVER_OFFSET
	
	if _vfx_tween: _vfx_tween.kill()
	
	_vfx_tween = %CardVfx.create_tween()
	_vfx_tween.tween_property(%CardVfx, "position", Vector2(0, offset), 0.05)
	
	_update_selection()

## Handles click to drag and moving the card to the mouse
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not _can_select.call(self): return
		
		if event.pressed and not _dragging and _hovering:
			_dragging = true
			_drag_offset = global_position - get_global_mouse_position()
			_update_selection()
		elif _dragging:
			_dragging = false
			_card_hover(_hovering)
			_update_selection()
			if not _call_position_update:
				var offset := global_position - _root_position
				_tween_position(_root_position, offset.length() / 16_500, true)
			else:
				_call_position_update.call()
			if _tween:
				_tween.chain().tween_callback(_reorder_child_index)
		
	if event is InputEventMouseMotion and _dragging:
		var target_pos := get_global_mouse_position() + _drag_offset
		_tween_position(target_pos, 0.075, true)
		if not _reorder_child_index():
			_call_position_update.call()
		
## Tweens the position to the [param pos] over [param time] seconds.
func _tween_position(pos: Vector2, time: float, animate_rotation: bool, rot: float = 0.0) -> void:
	if _tween: _tween.kill()
	
	var x_diff := pos.x - global_position.x
	var rot_scale : float = clamp(x_diff / MAX_VFX_ROTATION_DISTANCE, -1.0, 1.0)
	var peak_rotation := deg_to_rad(rot_scale * MAX_VFX_ROTATION)
	
	_tween = create_tween()
	_tween.set_parallel(true)
	
	_tween.tween_property(self, "global_position", pos, time)
	
	if rot == 0.0 or animate_rotation:
		_tween.tween_property(%CardVfx, "rotation", peak_rotation, time * 0.5)
		_tween.chain().tween_property($CardVfx, "rotation", rot, time * 0.5)
	else:
		_tween.tween_property(%CardVfx, "rotation", rot, time * 0.5)
	
	target_position = pos

## Updates the card position based on index and pivot
func _update_position(selected_index: int, angle: float, angle_offset: float, skip_selected: bool) -> void:
	if _dragging: return
	var index := get_index()
	
	# seperate from selected with additional offset
	if skip_selected:
		if index >= selected_index: index -= 1
	elif selected_index >= 0:
		if selected_index < get_index():
			angle_offset += deg_to_rad(SELECTED_SEPERATION)
		elif selected_index > get_index():
			angle_offset -= deg_to_rad(SELECTED_SEPERATION)
	
	# gather values
	var total_angle := angle_offset + (angle * index)
	var card_rotation := total_angle + deg_to_rad(90)
	var direction := Vector2(cos(total_angle), sin(total_angle))
	var t_position := \
		_pivot.global_position + \
		direction * absf(_pivot.position.y) + \
		Vector2(0, get_parent_control().position.y)
	
	# apply tween
	_tween_position(t_position, 0.075, false, card_rotation)

## Reorder child ordering based on x-positions. Returns if a reordering and position update was called
func _reorder_child_index() -> bool:
	var idx := get_index()
	var p := get_parent_control()
	var my_angle := _get_target_angle_to_pivot(self)
	
	var offset := 0.0
	if _dragging:
		offset = deg_to_rad(SELECTED_SEPERATION)
	
	if idx > 0:
		if _get_target_angle_to_pivot(p.get_child(idx - 1)) + offset > my_angle:
			p.move_child(self, idx - 1)
			_call_position_update.call()
			return true
	
	if idx < p.get_child_count() - 1:
		if _get_target_angle_to_pivot(p.get_child(idx + 1)) - offset < my_angle:
			p.move_child(self, idx + 1)
			_call_position_update.call()
			return true
	
	return false

## Returns the angle from the pivot to the node.
func _get_target_angle_to_pivot(node: Card) -> float:
	var direction := (node.target_position - _pivot.global_position).normalized()
	return atan2(direction.y, direction.x)