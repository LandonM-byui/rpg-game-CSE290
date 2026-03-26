extends Control
class_name CardVfx

func initialize(color: Color, card_name: String) -> void:
	%CARD_COLOR.color = color
	%CARD_NAME.text = card_name