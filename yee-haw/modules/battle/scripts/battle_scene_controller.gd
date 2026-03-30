extends SceneController

## A custom scene controller for the battle game scene.
class_name BattleSceneController

@export_group("VFX controls")
@export var hand_vfx : HandContainer
@export var discard_vfx : CardVfx
@export var discard_vfx_source : Control
@export var deck_vfx : CardVfx
@export var deck_vfx_source : Control

var _bc : BattleContext

## Open menu on "show_ui"
func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("show_ui"): return
	open_subscene.emit(SubSceneButton.SubSceneReference.GameMenu)
	
func load_scene(pd: ProjectData) -> void:
	_bc = BattleContext.NewContext(pd)
	
	hand_vfx.initialize()
	var hand := _bc.draw_cards(7)
	hand_vfx.add_to_hand(hand)
	
	discard_vfx.initialize(pd.deck_preset.color, "")
	deck_vfx.initialize(pd.deck_preset.color, "")
	_update_vfx()

func unload_scene(pd: ProjectData) -> void:
#	BattleService.return_cards_to_project(pd, _bc, hand_vfx.retrieve_cards())
	pass
	
func _update_vfx() -> void:
	discard_vfx_source.visible = len(_bc.discard) > 0
	deck_vfx_source.visible = len(_bc.deck) > 0
