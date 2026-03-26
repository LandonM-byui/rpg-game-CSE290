extends Control
class_name HandContainer

const SCENE_LOAD_DELAY : float = 2.0
const CARD_DRAW_DELAY : float = 0.05

## Location of the deck to draw cards from
@export var deck_source : Control
## Location of the discard to send card after use
@export var discard_source : Control

## Maximum angle of the hand spread from pivot
const MAX_TOTAL_ANGLE : float = 20.0
## Default angle offset per card
const DEFAULT_ANGLE : float = 3.5

## Is a child card currently being selected?
var _child_selected : bool
## Selected child, if any
var _selected_child : Control

## Signals to child cards to update their positions
signal update_positions(selected_index: int, angles: float, start_angle: float, skip_selected: bool)

## Returns an array of all indexed cards in-hand
func retrieve_cards() -> Array[IndexedCard]:
	var cards : Array[IndexedCard] = []
	
	for child in %CARD_CONTAINER.get_children():
		if not child is Card: continue
		cards.append((child as Card).indexed_card)
	
	return cards

## Clears all pre-loaded VFX
func initialize() -> void:
	for child in %CARD_CONTAINER.get_children():
		child.queue_free()
	
	_child_selected = false
	_selected_child = null

## Adds an indexed card to hand as an interactable VFX node
func add_to_hand(hand: Array[IndexedCard]) -> void:
	await get_tree().create_timer(SCENE_LOAD_DELAY).timeout
	for ic in hand:
		_add_card(ic)
		await get_tree().create_timer(CARD_DRAW_DELAY).timeout

## Adds a single card VFX to hand
func _add_card(card: IndexedCard):
	var c := preload("uid://bukkanr4pda5r").instantiate() as Card
	c.connect_data(card)
	c.connect_selection_dependence(_can_select, _update_selection)
	c.connect_pivot_positioning(%PIVOT, update_positions, _call_position_update)
	%CARD_CONTAINER.add_child(c)
	c.owner = %CARD_CONTAINER.owner
	
	if deck_source:
		c.global_position = deck_source.global_position
		c.global_position.y -= 500
	else:
		c.position.x = c.get_index()
	
	_call_position_update()
	
## Updates the selection status of child cards
func _update_selection(child: Control, select: bool) -> void:
	if select:
		_select_child(child)
	else:
		_deselect_child(child)
	_call_position_update()

## Selects the child control
func _select_child(child: Control) -> void:
	_child_selected = true
	_selected_child = child

## Deselects the child control
func _deselect_child(child: Control) -> void:
	if not child == _selected_child: return
	_child_selected = false
	_selected_child = null

## Returns true if the indexed child is allowed to show hover vfx
func _can_select(child: Control) -> bool:
	if _child_selected and _selected_child != child:
		return false
	
	return true

## Calls position update on children
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
	if active_cards == 1:
		indiv_angle = 0
	var start_angle := deg_to_rad((total_angle * -0.5) - 90)
	
	
	update_positions.emit(selected_index, indiv_angle, start_angle, skip_selected)
