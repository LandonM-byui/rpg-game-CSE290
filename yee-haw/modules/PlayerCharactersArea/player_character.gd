extends Node2D
class_name PlayerCharacter

signal player_clicked(pos)

var player_id := 0
var char_name := ""
var player_position := []
var player_health := 10
var player_max_health := 10
var defense := 0
var moved := 0
var current := false

func initialize(id: int, node_name: String, in_party: bool, row: int, column: int) -> void:
	player_id = id;
	current = in_party;
	char_name = node_name;
	player_position.append(row)
	player_position.append(column)
	$Health.text = str(player_health) + "/" + str(player_max_health)
	
func _set_player_position(row: int, column: int) -> void:
	player_position.clear()
	player_position.append(row)
	player_position.append(column)


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		#if not _get_topmost():
			#return
		player_clicked.emit(player_position)

func _get_topmost():
	var space_state := get_world_2d().direct_space_state
	
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collide_with_bodies = true
	
	var results := space_state.intersect_point(query)
	
	var best = null
	var highest_z := -INF
	
	for r in results:
		var obj = r.collider
		
		if obj.has_method("_set_player_position"):
			if obj.z_index > highest_z:
				highest_z = obj.z_index
				best = obj
	
	return best

func add_moves(moves: int):
	moved -= moves
	
func mod_defense(val: int):
	print(val)
	defense += val

func take_dmg(val):
	print(defense,val)
	if defense > val:
		defense -= val
	else:
		val -= defense
		player_health -= val
		defense = 0
		$Health.text = str(player_health) + "/" + str(player_max_health)
		death_check()
		

func death_check():
	if player_health <= 0:
		var row = player_position[0]
		var col = player_position[1]
		get_parent().player_grid_array[row][col] = null
		queue_free()
	
func toggle_hit_box():
	if $Area2D/CollisionShape2D.disabled == true:
		$Area2D/CollisionShape2D.disabled = false
	else:
		$Area2D/CollisionShape2D.disabled = true

func _select():
	$Area2D/SamsonBase.modulate = Color(0, 1, 0)
func _un_highlight():
	$Area2D/SamsonBase.modulate = Color(1, 1, 1)
	
func select():
	_select()
	
func deselect():
	_un_highlight()
