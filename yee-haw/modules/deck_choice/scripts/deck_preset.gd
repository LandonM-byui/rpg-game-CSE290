extends Resource

## Describes a deck preset for a run with [member base_cards] that are always included. Should
## generally have some built in combos and balanced cards, but most power and better combos will
## come from the heroes chosen and other cards added.
class_name DeckPreset

## Deck name
@export var name : String = "Unnamed Deck"

## Base hero included with the deck
@export var base_hero : CharacterData

## Base cards included in the chosen deck
@export var base_cards : Dictionary[CardData, int]

## Deck color TODO temporary until vfx added
@export var color : Color