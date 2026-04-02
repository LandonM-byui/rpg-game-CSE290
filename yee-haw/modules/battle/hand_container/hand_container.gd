extends Control
class_name HandContainer

const SCENE_LOAD_DELAY : float = 2.0
const CARD_DRAW_DELAY : float = 0.05

## Location of the deck to draw cards from
@export var deck_source : Control
## Location of the discard to send card after use
@export var discard_source : Control

@export var bc : BattleSceneController

@export var card_text : Label

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
#func retrieve_cards() -> Array[IndexedCard]:
#	var cards : Array[IndexedCard] = []
#	
#	for child in %CARD_CONTAINER.get_children():
#		if not child is Card: continue
#		cards.append((child as Card).indexed_card)
#	
#	return cards

func _ready() -> void:
	card_text.hide()

## Clears all pre-loaded VFX
func initialize() -> void:
	for child in %CARD_CONTAINER.get_children():
		child.queue_free()
	
	_child_selected = false
	_selected_child = null

## Adds an indexed card to hand as an interactable VFX node
func add_to_hand(hand: Array[IndexedCard], initial_delay: bool = false) -> void:
	if initial_delay:
		await get_tree().create_timer(SCENE_LOAD_DELAY).timeout
	
	for ic in hand:
		_add_card(ic)
		await get_tree().create_timer(CARD_DRAW_DELAY).timeout

## Adds a single card VFX to hand
func _add_card(card: IndexedCard):
	var c := preload("uid://bukkanr4pda5r").instantiate() as Card
	c.connect_data(card, bc)
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
	
	update_card_text()

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

func discard_hand() -> void:
	_selected_child = null
	_child_selected = false
	
	for child in %CARD_CONTAINER.get_children():
		if not child is Card: continue
		
		(child as Card).discard()
		
func update_card_text() -> void:
	if not _child_selected:
		card_text.hide()
		return
		
	if not _selected_child is Card:
		card_text.hide()
		return
		
	var card := (_selected_child as Card)._data
	var data := card.data
	var context := bc.context()
		
	var text := ""
	
	text += data.name
	if data.special:
		text += " (SPECIAL"
		if context.special_already_played:
			text += " - BLOCKED"
		text += ")"
	text += "\n"	
	
	if data.type == CardData.CardType.Junk: text += "Junk Card\n"
	if data.type == CardData.CardType.Item: text += "Item Card\n"
	if data.type == CardData.CardType.Attack: text += "Attack Card\n"
	if data.type == CardData.CardType.Buff: text += "Buff Card\n"
	
	text += "======\n"
	
	if data.type == CardData.CardType.Junk:
		text += "This card is useless junk."
		card_text.text = text
		card_text.show()
		return
	
	if data.type == CardData.CardType.Attack:
		var dmg_min : int = max(0, data.damage_range.x + card.stat_change + context.turn_damage_change)
		var dmg_max : int = max(0, data.damage_range.y + card.stat_change + context.turn_damage_change)
		if dmg_min >= dmg_max:
			text += "Deals " + str(dmg_min) + " damage"
		else:
			text += "Deals " + str(dmg_min) + " - " + str(dmg_max) + " damage"
		
		if data.targeting == CardData.AttackTarget.Column:
			text += " to a column"
		if data.targeting == CardData.AttackTarget.Row:
			text += " to a row"
		
		text += "\n"
		
	if data.type == CardData.CardType.Buff:
		if data.defense > 0:
			var def : int = max(0, data.defense + card.stat_change + context.turn_defense_change)
			text += "Adds " + str(def) + " defense\n"
		
		if data.extra_moves > 0:
			var moves : int= max(0, data.extra_moves + card.stat_change + context.turn_defense_change)
			text += "Gives " + str(moves) + " extra moves\n"
	
	# Card copies
	if data.card_copies > 0:
		text += "Creates " + str(data.card_copies)
		if data.card_copies > 1:
			text += " copies"
		else:
			text += " copy" 
		text += " in the "
		if data.create_source == CardData.CardSource.Deck: text += "deck"
		if data.create_source == CardData.CardSource.Hand: text += "hand"
		if data.create_source == CardData.CardSource.Discard: text += "discard"
		text += "\n"
	
	# created cards
	if len(data.create_cards) != 0:
		var created : Dictionary = {}
		for option in data.create_cards:
			created[option.name] = created.get(option.name, 0) + 1
		
		for n in created.keys():
			var count : int = created[n]
			text += "Creates " 
			if count > 1: text += "a "
			text += str(count) + " " + n + " card"
			if count > 1: text += "s"
			text += "\n"		
	
	# draw cards
	if data.draw_cards > 0:
		text += "Draw " + str(data.draw_cards) + " card"
		if data.draw_cards > 1: text += "s"
		if context.block_card_draw:
			text += " (BLOCKED)"
		text += "\n" 

	# destroy in deck
	if data.destroy_in_deck > 0:
		text += "Destroys " + str(data.destroy_in_deck) + " random card"
		if data.destroy_in_deck > 1: text += "s"
		text += " in the deck\n"
		
	# block card draw
	if data.block_card_draw:
		text += "Blocks card draw this turn"
	
	# turn stat changes
	if data.turn_def_change != 0:
		if data.turn_def_change > 0: text += "+"
		text += str(data.turn_def_change) + " damage this turn\n"
	
	if data.turn_def_change != 0:
		if data.turn_def_change > 0: text += "+"
		text += str(data.turn_def_change) + " defense this turn\n"
	
	# card battle stat change
	if data.perma_stat_change != 0:
		if data.perma_stat_change > 0: text += "+"
		text += str(data.perma_stat_change) + " to this cards stats this combat\n"
		
	if data.after_play == CardData.CardPermanance.Deck:
		text += "This card is put back into the draw pile"
	elif data.after_play == CardData.CardPermanance.Remove:
		text += "This card is destroyed"
	else:
		text += "Discarded after play"
	
	if data.special:
		text += "\n*only one special card can be played per turn"
	
	card_text.text = text
	card_text.show()
