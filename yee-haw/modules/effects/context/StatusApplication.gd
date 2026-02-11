extends Resource

## Defines conditions to apply a status
class_name StatusApplication

var status : Status
var stacks : int
var chance : int
var individual_chances : bool

static func Create(
in_status: Status, 
in_stacks: int, 
in_chance: int, 
in_individual_chances: bool
) -> StatusApplication:
	var sa := StatusApplication.new()
	sa.status = in_status
	sa.stacks = max(in_stacks, 0)
	sa.chance = max(in_chance, 0)
	sa.individual_chances = in_individual_chances
	return sa