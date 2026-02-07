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