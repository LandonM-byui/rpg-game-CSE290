extends SceneController

## A custom scene controller for the battle game scene.
class_name BattleSceneController

@export_group("VFX controls")
@export var hand_vfx : HandContainer
@export var discard_vfx : CardVfx
@export var discard_vfx_source : Control
@export var deck_vfx : CardVfx
@export var deck_vfx_source : Control
@export var end_turn_button : Button
@export var deck_count_label : Label
@export var discard_count_label : Label
@export var enemy_grid_controller : EnemyGridController

signal turn_start()


var _bc : BattleContext

var turn := -1

func context() -> BattleContext:
	return _bc

## Open menu on "show_ui"
func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("show_ui"): return
	open_subscene.emit(SubSceneButton.SubSceneReference.GameMenu)
	
func load_scene(pd: ProjectData) -> void:
	_bc = BattleContext.NewContext(pd)
	
	end_turn_button.pressed.connect(end_player_turn)
	
	discard_vfx.initialize(pd.deck_preset.color, "")
	deck_vfx.initialize(pd.deck_preset.color, "")
	_update_vfx()
	
	run_player_turn()

func unload_scene(_pd: ProjectData) -> void:
#	BattleService.return_cards_to_project(pd, _bc, hand_vfx.retrieve_cards())
	pass
	
func _update_vfx() -> void:
	discard_vfx_source.visible = len(_bc.discard) > 0
	deck_vfx_source.visible = len(_bc.deck) > 0
	
	discard_count_label.text = str(len(_bc.discard))
	deck_count_label.text = str(len(_bc.deck))

func add_cards_to_hand(count: int) -> void:
	var cards := _bc.draw_cards(count)
	hand_vfx.add_to_hand(cards)
	
func end_player_turn() -> void:
	if turn != 0: return
	
	hand_vfx.discard_hand()
	_bc.turn_end_reset()
	
	_update_vfx()
	$Game/PlayerGrids._reset_turn()
	
	run_enemy_turn()
	
	
func run_enemy_turn():
	turn = 1
	print("ENEMY TURN!: ")
	
	if enemy_grid_controller.get_enemy_count() == 0:
		(get_parent().get_parent() as GameHandler)._load_scene(FullSceneButton.GameSceneReference.DeckChoice)
	
	# TODO enemies attack players
	var temp_queue = $Game/'Enemy Grids'.attack_queue
	var temp_players = $Game/'Player Grids'.player_grid_array
	for r in range(temp_queue.size()):
		for dmg in temp_queue[r]:
			for c in range(temp_players[r].size() - 1, -1, -1):
				if temp_players[r][c] != null:
						temp_players[r][c].take_dmg(dmg)
						break
	if $Game/'Player Grids'._death_check() == 0:
		(get_parent().get_parent() as GameHandler)._load_scene(FullSceneButton.GameSceneReference.DeckChoice)
	_update_vfx()
	
	run_player_turn()
	
func run_player_turn():
	if $Game/'Player Grids'._death_check() == 0:
		(get_parent().get_parent() as GameHandler)._load_scene(FullSceneButton.GameSceneReference.DeckChoice)

	print("PLAYER TURN!")
	turn_start.emit()
	
	
	
	hand_vfx.initialize()
	var hand := _bc.draw_cards(7)
	await hand_vfx.add_to_hand(hand, true)
	
	_update_vfx()
	
	turn = 0
