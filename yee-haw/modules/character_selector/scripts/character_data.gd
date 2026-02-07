extends Resource

## Defines data for a character
class_name CharacterData

## Character name
@export var name : String
## Character color TODO Temporary until we can replace it with a texture reference for VFX
@export var color : Color
## All cards (and how many) are added to the deck when this hero is added
@export var included_cards : Dictionary[CardData, int]