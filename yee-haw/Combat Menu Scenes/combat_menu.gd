extends Control


func _on_weapons_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Combat Menu Scenes/weapons_menu.tscn")


func _on_items_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Combat Menu Scenes/items_menu.tscn")


func _on_move_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Combat Menu Scenes/move_menu.tscn")
