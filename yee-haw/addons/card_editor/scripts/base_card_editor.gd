@tool
extends Control
class_name BaseCardEditor

var _attack_editor : AttackCardEditor
var _res : Resource

func initialize(card: CardData) -> void:
	_res = card
	
	CESig.connect_text(%CARDNAME, "name", card)
	CESig.connect_color(%CARDCOLOR, "color", card)
	
	if not card is AttackCard: return
	
	_attack_editor = preload("res://addons/card_editor/scenes/AttackCardEditor.tscn").instantiate() as AttackCardEditor
	%"EDITOR SETTINGS".add_child(_attack_editor)
	_attack_editor.owner = %"EDITOR SETTINGS".owner
	
	_attack_editor.initialize(card as AttackCard)
