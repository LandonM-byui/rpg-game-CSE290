extends Node2D
class_name EnemyController

var enemy_data : Enemy

var grid_root : EnemyGridController

var health : int = 0

var grid_column : int = -1
var grid_row : int = -1

var row_ref : RowSelectionArea
var col_ref : ColumnSelectionArea
var remove : Callable
var deaded = false


func full_heal() -> void:
	health = enemy_data.max_health

func take_dmg(damage_value):
	if damage_value <= 0: return
	'''hit animations!'''
	#if enemy_data.sprite_path == 'res://art/ostrich_base.tscn':
		#var sprite = $ostrich_base
		#sprite.set_current_animation("hurt")
		#$second.start()
		#await $second.timeout
		#sprite.
#
	#elif enemy_data.sprite_path == 'res://art/weasel_base.tscn':
		#var sprite = $weasel_base
		#sprite.set_current_animation("hurt")
		

	health = max(0, health - damage_value)
	is_dead()

func is_dead():
	if health <= 0:
		row_ref.remove(self)
		col_ref.remove(self)
		remove.call()
		deaded = true
		queue_free()
		
		
func enemy_attack():
	var dmg = enemy_data.attack
	return dmg
	

func select():
	$cool_sprite.self_modulate = Color(1, 0, 0)
	$lame_sprite.self_modulate = Color(1, 0, 0)

func deselect():
	$cool_sprite.self_modulate = Color(1, 1, 1)
	$lame_sprite.self_modulate = Color(1, 1, 1)
