extends Control

## Controls all selectable child [Card] nodes.
class_name CardSelectionController

## How far away from the pivot [Control] the cards are.
const PIVOT_OFFSET : float = 2800
## Standard pivot angle (degrees) for cards off the pivot node.
const NORMAL_PIVOT : float = 6.0
## Maximum angle the cards in hand can span off the pivot node.
const MAX_PIVOT_ANGLE : float = 35.0
## How far other cards around the hovered card (if any) pivot away in angles (degrees).
const MOUSE_HOVER_PIVOT : float = 3.0
## How far other cards are downset. Downset occurs when another card is being dragged, or 
## when the selection controller is out of focus.
const NON_GRABBED_DOWNSET : float = 500
## How far away the mouse is from this controller before card downset is forced.
const DOWNSET_OVER_DISTANCE : float = 250

## Pivot point for cards.
@export var card_pivot : Control

## All cards in hand.
var _cards : Array[Card] = []
## Last grabbed card.
var _last_grabbed : Card = null

func _process(_delta: float) -> void:
	# no updates when no children
	if get_child_count() == 0: return
	# similar, no updates when no cards
	if len(_cards) == 0: return
	
	if Engine.is_editor_hint():
		_update_card_positioning()
	_update_card_positions()

## Assigns all children that are [Card] nodes into the [member _cards] array.
func _get_cards() -> void:
	var card_children : Array[Card] = []
	
	for child in get_children():
		# only add visible cards
		if not child is Card: continue
		if not child.visible: continue
		card_children.append(child as Card)
		
	_cards = card_children

## Updates the target positions and rotations of all child cards.
func _update_card_positions() -> void:
	var child_count: int = len(_cards) - 1
	
	var card_hovered := _is_card_hovered()
	var card_grabbed := _is_card_grabbed()
	var grabbed_card := _get_grabbed_card()
	var grabbed_direction : float = 0
	var mouse_beyond_dist := _is_mouse_beyond_dist()
	
	if card_grabbed:
		grabbed_direction = _get_grabbed_direction(grabbed_card)
		_last_grabbed = grabbed_card
	else:
		if not _last_grabbed == null:
			_update_card_positioning()
			_last_grabbed = null
	
	var child_pivot = min(NORMAL_PIVOT, MAX_PIVOT_ANGLE / child_count)
	var pivot_center : float = -90.0
	var hover_found : bool = false
	
	for i in range(len(_cards)):
		# get card
		var card := _cards[i]
		if card.grabbed: continue
		
		# get the pivot offset
		# if a card is hovering, offset cards before and after the hovered card
		# if grabbed, offset from before and after grab direction
		var center_offset := (i - (len(_cards) / 2.0))
		var rot := deg_to_rad(center_offset * child_pivot + pivot_center)
		var hover_pivot_offset : float = 0
		if card_grabbed:
			if rot < grabbed_direction:
				hover_pivot_offset = -MOUSE_HOVER_PIVOT
			else:
				hover_pivot_offset = MOUSE_HOVER_PIVOT
		elif card_hovered and not card.mouse_hover:
			if hover_found:
				hover_pivot_offset = MOUSE_HOVER_PIVOT
			else:
				hover_pivot_offset = -MOUSE_HOVER_PIVOT
		hover_pivot_offset = deg_to_rad(hover_pivot_offset)
		rot += hover_pivot_offset
	
		# get the card rotation
		var card_rot := deg_to_rad((i - (child_count / 2.0)) * child_pivot) + hover_pivot_offset
		
		# track hovered card as found
		if card_hovered and card.mouse_hover:
			hover_found = true
		
		# get position from pivot
		var offset : float = PIVOT_OFFSET
		if mouse_beyond_dist and not card.grabbed:
			offset -= NON_GRABBED_DOWNSET
		var pivot_pos := Vector2(cos(rot), sin(rot)) * offset
		
		# in-game, smooth towards targets
		card.target_position_global = card_pivot.global_position + pivot_pos
		card.target_rotation = card_rot

## Returns true if any tracked cards are being hovered.
func _is_card_hovered() -> bool:
	for card in _cards:
		if card.mouse_hover:
			return true
	
	return false

## Returns true if any tracked cards are being grabbed.
func _is_card_grabbed() -> bool:
	for card in _cards:
		if card.grabbed:
			return true
	
	return false

## Returns the [Card] being grabbed, if any, else returns [null].
func _get_grabbed_card() -> Card:
	for card in _cards:
		if card.grabbed:
			return card
	
	return null

## Returns the direction from the pivot node the card is. Used to determine card spacing 
## as the card is being dragged around.
func _get_grabbed_direction(card: Card) -> float:
	if card == null: return 0.0
	var diff := (card.global_position - card_pivot.global_position).normalized()
	return atan2(diff.y, diff.x)

## Returns true if the mouse is beyond the maximum range for card downset.
func _is_mouse_beyond_dist() -> float:
	var diff := get_global_mouse_position() - card_pivot.global_position
	return diff.length() - PIVOT_OFFSET >= DOWNSET_OVER_DISTANCE

## Updates the child order and index order within [member _cards] for each card based on their x-position.
## Order is important for positioning the cards within the hand.
func _update_card_positioning() -> void:
	## sort cards by x positioning low to high 
	_cards.sort_custom(func(a, b): 
		return a.position.x < b.position.x
	)
	
	## update child positioning
	for i in range(len(_cards)):
		var card := _cards[i]
		move_child(card, i)


# ------------ ------------ ------------ ------------ ------------ ------------ ------------
# ------ External control from scene root ----------- ------------ ------------ ------------
# ------------ ------------ ------------ ------------ ------------ ------------ ------------


@export_group("Card Generation")
@export var card_prefab : PackedScene
@export var deck_source : Control
@export var discard_source : Control

# Removes all vfx cards from hand
func clear_hand_vfx() -> void:
	_cards = []
	for child in get_children():
		child.queue_free()

## Adds all cards to hand
func add_to_hand(hand: Array[IndexedCard]) -> void:
	for ic in hand:
		add_card_to_hand(ic)

## Adds a single card to hand
func add_card_to_hand(ic: IndexedCard) -> void:
	var card := card_prefab.instantiate() as Card
	card.global_position = deck_source.global_position
	card.assign_from_indexed_card(ic)
	
	add_child(card)
	card.owner = owner
	
	_cards.append(card)
