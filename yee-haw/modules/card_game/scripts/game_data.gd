extends Resource
class_name GameData

## Cards in deck
var deck : Array[Card]

## Cards in discard
var discard : Array[Card]

# Track Removed cards? (not in deck until battle end)

## Current played heroes
var heroes : Array[ActiveCharacter]

## Current played enemies
var enemies : Array[ActiveEnemy]

# Current shot order | Possible selected_hero | rotates automatically after each attack


## Creates the game preset from chosen party
static func CreatePreset(roster: Array[CharacterData], deck_preset: DeckPreset) -> GameData:
	var data := GameData.new()
	
	# TODO deck presets for base cards
	
	var d : Array[Card] = []
	for card in deck_preset.base_cards:
		for _i in range(deck_preset.base_cards[card]):
			d.append(card)
	for hero in roster:
		for card in hero.included_cards:
			for _i in range(hero.included_cards[card]):
				d.append(card)
	data.deck = d
	
	data.discard = []
	
	var h : Array[ActiveCharacter] = []
	for hero in roster:
		h.append(ActiveCharacter.Create(hero))
	data.heroes = h
	
	# TODO: Encounter generation? Enemy location presets
	data.enemies = []
	
	return data