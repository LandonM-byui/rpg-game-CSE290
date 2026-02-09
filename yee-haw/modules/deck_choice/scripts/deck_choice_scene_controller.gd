@tool
extends SceneController
class_name DeckChoiceSceneController

@export_group("VFX Update Data")

var _current_choice : int
@export var current_choice : int:
	get: return _current_choice
	set(val):
		_set_curr_choice(val)
		_update_vfx()

@export var valid_decks : Array[DeckPreset]
@export var deck_display_container : Control
@export var card_back_display : CardBack
@export var deck_name_label : Label

@onready var _small_card_prefab : PackedScene = preload(CRef.SMALL_CARD_PREFAB)

@export var force_reload_vfx: bool:
	get: return false
	set(val):
		if val == false: return
		_update_vfx()
		force_reload_vfx = false

@export_group("Signal Connections")
@export var up_button : BaseButton
@export var down_button : BaseButton

func _update_vfx() -> void:
	if valid_decks == null: return
	if valid_decks.size() == 0: return
	if deck_display_container == null: return
	if card_back_display == null: return
	if deck_name_label == null: return
	if _small_card_prefab == null: return

	for child in deck_display_container.get_children():
		child.queue_free()
	
	var deck := valid_decks[current_choice]
	for cd in deck.base_cards:
		for _i in range(deck.base_cards[cd]):
			_add_card_to_group(cd)
	for cd in deck.base_hero.included_cards:
		for _i in range(deck.base_hero.included_cards[cd]):
			_add_card_to_group(cd)
	
	card_back_display.data = deck
	deck_name_label.text = deck.name

func _add_card_to_group(data: CardData) -> void:
	var card := _small_card_prefab.instantiate() as SmallCard
	card.data = data
	deck_display_container.add_child(card)
	card.owner = deck_display_container.owner

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	current_choice = 0
	
	if up_button != null:
		up_button.pressed.connect(_decrement_choice)
	if down_button != null:
		down_button.pressed.connect(_increment_choice)

func _set_curr_choice(val: int) -> void:
	if valid_decks == null or len(valid_decks) == 0:
		_current_choice = 0
		return
	
	if val < 0:
		var steps := floori(float(abs(val)) / len(valid_decks))
		val += len(valid_decks) * steps
	
	_current_choice = val % len(valid_decks)
	

func _increment_choice() -> void:
	_set_curr_choice(_current_choice + 1)
	_update_vfx()

func _decrement_choice() -> void:
	_set_curr_choice(_current_choice - 1)
	_update_vfx()
	
func unload_scene(pd: ProjectData) -> void:
	_save_deck_to_project(pd)

func _save_deck_to_project(pd: ProjectData) -> void:
	pd.clear_all_cards()
	var deck := valid_decks[current_choice]
	
	for cd in deck.base_cards:
		for _i in range(deck.base_cards[cd]):
			pd.add_card_to_deck(cd)
	for cd in deck.base_hero.included_cards:
		for _i in range(deck.base_hero.included_cards[cd]):
			pd.add_card_to_deck(cd)
	
	pd.shuffle_deck()
	
	pd.deck_preset = deck