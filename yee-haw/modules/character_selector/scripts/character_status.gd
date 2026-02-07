extends Resource

## Defines a status that character can gain or be afflicted with.
## TODO : Create sub-classes for specific general effects:
##	- damaging per-turn
##  - healing per turn
## 	- other?
class_name CharacterStatus

## Name of the status
@export var name : String