extends Control

## A UI card node that reacts to mouse actions. Must be a child of a [CardSelectionController] to be interactive.
class_name Card


# -----------------------------------------------------
# Variables
# -----------------------------------------------------

# CONSTANTS
## How many extra degrees to pivot away from the selected card
const SELECTED_SEPERATION : float = 1.5
## How far the VFX are offset on mouse hover
const HOVER_OFFSET : float = 40.0
## Distance required to rotate [member MAX_VFX_ROTATION]
const MAX_VFX_ROTATION_DISTANCE : float = 400
## Max rotation (degrees) at [member MAX_VFX_ROTATION_DISTANCE]
const MAX_VFX_ROTATION : float = 30.0

const DRAG_OFFSET : Vector2 = Vector2(0, 150)

## Card data
@export var _data : IndexedCard

var indexed_card : IndexedCard:
	get: return _data

# STATE TRACKING
## True when the mouse is hovering
var _hovering: bool = false
## True when the card is being dragged by the mouse
var _dragging: bool = false
## Root position of the card on _ready
var _root_position: Vector2
## Current target postion
var target_position : Vector2

## UNIQUE TWEENS
## Current position/rotation tween on card
var _tween: Tween
## Current tween on the vfx
var _vfx_tween: Tween

var _bc : BattleSceneController


# -----------------------------------------------------
# Adaptors
# -----------------------------------------------------

## Positioning pivot point
var _pivot : Control
## When called forces position updates on all cards in container
var _call_position_update : Callable

var prevent_all_actions : bool = false

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
bc: BattleSceneController
) -> void:
	_data = data
	_bc = bc
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

	mouse_entered.connect(func(): if is_instance_valid(self): _card_hover(true))
	mouse_exited.connect(func(): if is_instance_valid(self): _card_hover(false))
	
	_card_hover(false)

## Handles tweening the vfx position to show a card hover/not.
func _card_hover(is_hovering: bool) -> void:
	if prevent_all_actions: return

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
			
			_update_selection()
		elif _dragging:
			_deselect_last_selected()
		
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
			
			_collide_at_pos()
		
	if event is InputEventMouseMotion and _dragging:
		var target_pos := get_global_mouse_position() + DRAG_OFFSET
		_tween_position(target_pos, 0.075, true)
		if not _reorder_child_index():
			_call_position_update.call()
			
		_show_selection()
		
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

func _get_collision_layer() -> int:
	if _data.data.type == CardData.CardType.Attack:
		if _data.data.targeting == CardData.AttackTarget.Single: return 5
		if _data.data.targeting == CardData.AttackTarget.Row: return 6
		if _data.data.targeting == CardData.AttackTarget.Column: return 7
	
	if _data.data.type == CardData.CardType.Buff:
		return 9
		
	if _data.data.type == CardData.CardType.Item:
		return 10
		
	return -1

func _get_pos_collision() -> CollisionObject2D:
	var space_state := get_world_2d().direct_space_state
	
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	
	var collision_layer := _get_collision_layer()
	if collision_layer == -1: return null
	
	params.collision_mask = 2 ** (collision_layer - 1)
	params.collide_with_areas = true
	params.collide_with_bodies = true
	
	var results := space_state.intersect_point(params, 32)
	
	if len(results) == 0:
		return null
	
	return results[0]["collider"]

var last_selected = null
	
func _show_selection() -> void:
	var coll = _get_pos_collision()
	if coll == null: 
		_deselect_last_selected()
		return
	
	if _data.data.type == CardData.CardType.Attack and _data.data.targeting == CardData.AttackTarget.Single:
		coll = coll.get_parent()
	
	if _data.data.type == CardData.CardType.Buff:
		coll = coll.get_parent()	
		
	if _data.data.type == CardData.CardType.Item: return	
	
	if coll == last_selected: return
	
	_deselect_last_selected()
	last_selected = coll
	coll.select()
	
func _deselect_last_selected() -> void:
	if last_selected == null: return
	last_selected.deselect()
	last_selected = null

func _collide_at_pos() -> void:
	var coll := _get_pos_collision()
	if coll == null: return

	_run_card_actions(coll)
	
func _run_card_actions(collided_node: CollisionObject2D):
	if _data.data.special and _bc.context().special_already_played:
		prevent_all_actions = false
		return

	prevent_all_actions = true

	if _data.data.type == CardData.CardType.Attack:
		if _data.data.targeting == CardData.AttackTarget.Single:
			var en := collided_node.get_parent() as EnemyController
			_attack_enemy([en])
			_card_played()
			return
			
		if _data.data.targeting == CardData.AttackTarget.Row: 
			var row_selector := collided_node as RowSelectionArea
			if len(row_selector.enemy_refs) == 0: return
			_attack_enemy(row_selector.enemy_refs.duplicate())
			_card_played()
			return

		if _data.data.targeting == CardData.AttackTarget.Column: 
			var col_selector := collided_node as ColumnSelectionArea
			if len(col_selector.enemy_refs) == 0: return
			_attack_enemy(col_selector.enemy_refs.duplicate())
			_card_played()
			return
	
	if _data.data.type == CardData.CardType.Buff:
		var player : PlayerCharacter = collided_node.get_parent() as PlayerCharacter
		_buff_player(player)
		
	if _data.data.type == CardData.CardType.Item:
		_card_played()
		
func _buff_player(player: PlayerCharacter) -> void:
	if _data.data.extra_moves > 0:
		player.add_moves(_data.data.extra_moves)
		
	var defend : int = max(0, _data.data.defense + _bc.context().turn_defense_change + _data.stat_change)
	if defend > 0:
		player.mod_defense(defend)
	
	_card_played()
		
func _attack_enemy(ens: Array[EnemyController]) -> void:
	var dmg_min : int = max(_data.data.damage_range.x, _data.data.damage_range.y)
	var dmg_max := _data.data.damage_range.x
	
	for en in ens:
		for _a in range(_data.data.triggers):
			var d : int = max(0, randi_range(dmg_min, dmg_max) + _bc.context().turn_damage_change + _data.stat_change)
			en.take_dmg(d)
			
func _card_played() -> void:
	var context := _bc.context()

	# Card copies
	if _data.data.card_copies > 0:
		if _data.data.create_source == CardData.CardSource.Deck:
			for _i in range(_data.data.card_copies):
				context.create_in_deck([_data.data])
		
		if _data.data.create_source == CardData.CardSource.Hand:
			var cards : Array[IndexedCard] = []
			for _i in range(_data.data.card_copies):
				cards.append(context.create_card(_data.data))
			_bc.hand_vfx.add_to_hand(cards)
			
		if _data.data.create_source == CardData.CardSource.Discard:
			for _i in range(_data.data.card_copies):
				context.create_in_discard([_data.data])
	
	# created cards
	if len(_data.data.create_cards) != 0:
		var created : Array[IndexedCard] = []
		for data in _data.data.create_cards:
			created.append(context.create_card(data))
		
		if _data.data.create_source == CardData.CardSource.Deck:
			for card in created:
				context.add_to_deck(card)
		
		if _data.data.create_source == CardData.CardSource.Hand:
			_bc.hand_vfx.add_to_hand(created)
			
		if _data.data.create_source == CardData.CardSource.Discard:
			for card in created:
				context.add_to_discard(card)
	
	# draw cards	
	if _data.data.draw_cards > 0 and not context.block_card_draw:
		_bc.add_cards_to_hand(_data.data.draw_cards)

	# destroy in deck
	if _data.data.destroy_in_deck > 0:
		# no storage, so destroyed
		context.draw_cards(_data.data.destroy_in_deck)
		
	# block card draw
	if _data.data.block_card_draw:
		context.block_card_draw = true
	
	# track specials played
	if _data.data.special:
		context.special_already_played = true
	
	# turn stat changes
	context.turn_damage_change += _data.data.turn_def_change
	context.turn_defense_change += _data.data.turn_def_change
	
	# card battle stat change
	if _data.data.perma_stat_change != 0:
		_data.stat_change += _data.data.perma_stat_change
	
	# card destroyed on total stat loss
	var force_remove := false
	if _data.data.perma_stat_change < 0:
		var max_dmg : int = max(_data.data.damage_range.x, _data.data.damage_range.y)
		var max_buff : int = max(_data.data.defense, _data.data.extra_moves, _data.data.draw_cards)
		var max_stat : int = max(max_dmg, max_buff)
		
		if max_stat + _data.stat_change <= 0:
			force_remove = true

	if not force_remove:
		if _data.data.after_play == CardData.CardPermanance.Discard:
			context.add_to_discard(_data)
		
		if _data.data.after_play == CardData.CardPermanance.Deck:
			context.add_to_deck(_data)
	
	# after_play == Remove
	
	get_parent().remove_child(self)
	
	_hovering = false
	_dragging = false
	_update_selection()
	
	_bc._update_vfx()
	
	queue_free()

func discard() -> void:
	_bc.context().add_to_discard(_data)
	_bc._update_vfx()
	
	get_parent().remove_child(self)
		
	_hovering = false
	_dragging = false
	_update_selection()
	
	queue_free()
