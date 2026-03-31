extends CollisionObject2D
## Defines an entire enemy column as a selection area.
class_name ColumnSelectionArea

@export var enemy_refs : Array[EnemyController] = []

func select() -> void:
	for en in enemy_refs:
		en.select()

func deselect() -> void:
	for en in enemy_refs:
		en.deselect()
		
func add_reference(enemy: EnemyController) -> void:
	enemy_refs.append(enemy)

func remove(enemy: EnemyController) -> void:
	for i in range(len(enemy_refs)):
		if not enemy_refs[i] == enemy: continue
			
		enemy_refs.pop_at(i)
		return