@tool
extends Control

## A UI card node that reacts to mouse actions. Must be a child of a [CardSelectionController] to be interactive.
class_name Card

## Tracks if the mouse is hovering over this card.
var mouse_hover : bool = false
## How far up the VFX assets are pushed during mouse hover. (Increases visibility)
const HOVER_OFFSET : float = 80.0
## True if the card is currently being dragged by the mouse.
var grabbed : bool = false
## Tracked offset from card to mouse when first grabbed to maintain the offset during drag.
var grab_offset : Vector2

# Animation variables for smooth lerp from current values to targets
## The current global target position of the card it wants to be placed at.
var target_position_global : Vector2 = Vector2.ZERO
## The current rotation/orientation the card wants to be at
var target_rotation : float = 0.0
## The current target y the vfx wants to be at
var target_vfx_y : float = 0.0

## Smoothing factor during lerp from any current values to targets
const SMOOTHING : float = 0.18

## Card data represented by this card
var _data : CardData
## Exposed [member _data] to update vfx when changed
@export var data: CardData:
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

## Label that displays the card name
var _label : Label
## Exposed [member _label] to update vfx when changed
@export var label : Label:
	get: return _label
	set(val):
		_label = val
		_update_vfx()

## The container with all vfx assets that is moved around for seleciton visibility. See [member HOVER_OFFSET].
@export var vfx_container : Control

## Updates the vfx with card color and card name
func _update_vfx() -> void:
	if _data == null: return
	if _col_rect == null: return
	if _label == null: return
	
	_col_rect.color = _data.color
	_label.text = _data.name

func _process(_delta: float) -> void:
	# only update the card hand placement in-engine
	if Engine.is_editor_hint():
		return
	
	# track mouse hover
	_hover_update_vfx()
	
	# track grabbing
	if grabbed:
		mouse_filter = MOUSE_FILTER_IGNORE
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			grabbed = false
	if not grabbed:
		mouse_filter = MOUSE_FILTER_STOP
	
	# move cards
	_update_placement()
	
	# update intersection graphics
	_attack_card_intersection()

## Updates the vfx when hovered to slightly lift up vfx
func _hover_update_vfx() -> void:
	if vfx_container == null:
		return

	if mouse_hover:
		target_vfx_y = -HOVER_OFFSET
	else:
		target_vfx_y = 0
	
	vfx_container.position.y = lerp(vfx_container.position.y, target_vfx_y, SMOOTHING)

## Updates the cards position and rotation towards their target position and rotation
func _update_placement() -> void:
	if grabbed:
		target_position_global = get_global_mouse_position() + grab_offset
		var x_diff := global_position.x - target_position_global.x
		var scaled_diff := x_diff / 400
		var clamped_diff : float = min(1.0, max(-1.0, scaled_diff))
		target_rotation = deg_to_rad(clamped_diff * 25.0)

	global_position = lerp(global_position, target_position_global, SMOOTHING)
	rotation = lerp(rotation, target_rotation, SMOOTHING)

# tracking mouse hovering
func _on_mouse_exited():
	mouse_hover = false
func _on_mouse_entered():
	mouse_hover = true

# track left mouse-click to initiate dragging
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

## Tracks last selected [EnemySelectionArea] to deselect properly when changing
var last_selected : EnemySelectionArea = null
## When dragging, gets the intersected attack areas that are valid with the dragged attack card
func _attack_card_intersection() -> void:
	if not grabbed: 
		_clear_selection()
		return
	# >>> Card is being grabbed and dragged by mouse, ...
	
	if not _data is AttackCard:
		_clear_selection()
		return
	# >>> ... Card is an attack card, ...
	#... then ...
	
	# Cast the mouse into the game looking for [EnemySelectionArea] nodes
	var _hit := _get_mouse_cast()
	if _hit.size() == 0:
		_clear_selection()
		return
	
	if not _hit["collider"] is EnemySelectionArea:
		_clear_selection()
		return
	
	# on hit with an area, no update if it was aready selected before
	var esa := _hit["collider"] as EnemySelectionArea
	if esa == last_selected: return
	
	# otherwise clear last selection and re-select the current area
	_clear_selection()
	esa.select()
	last_selected = esa

## Gets the collided objects at the mouse position on the layer defined by an attack card.
## Will break if called and this current card is not an attack card.
func _get_mouse_cast() -> Dictionary:
	# cast a 2D query at the mouse position in the game world
	var mouse_pos := get_global_mouse_position()
	var space_state := get_world_2d().direct_space_state

	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collision_mask = (_data as AttackCard).get_selection_layer()
	query.collide_with_bodies = true
	query.collide_with_areas = true
	
	# get intersection right under the mouse
	var result := space_state.intersect_point(query, 1)
	
	# returns a single hit object or nothing
	if result.size() > 0:
		return result.front()
	return {}

## Deselects the last selected [EnemySelectionArea].
func _clear_selection() -> void:
	if last_selected == null:
		return
	last_selected.deselect()
	last_selected = null
	
# ------------ ------------ ------------ ------------ ------------ ------------ ------------
# ------ External control from scene root ----------- ------------ ------------ ------------
# ------------ ------------ ------------ ------------ ------------ ------------ ------------

var _indexed_card_base : IndexedCard

func assign_from_indexed_card(ic: IndexedCard) -> void:
	_indexed_card_base = ic
	data = ic.data

func get_indexed_card() -> IndexedCard:
	return _indexed_card_base