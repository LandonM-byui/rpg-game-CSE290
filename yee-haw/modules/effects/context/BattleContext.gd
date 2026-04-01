extends Resource

## All context used in-battle
class_name BattleContext

# Counters
# ----- ----- ----- ----- ----- ----- ----- 
## Total attacks used
var attacks_used_total : int = 0
## Attacks used this turn
var attacks_used_turn : int = 0
## All destroyed cards this round
var destroyed_cards : int = 0


# Game State
# ----- ----- ----- ----- ----- ----- ----- 
## All cards in hand
var hand : Array[IndexedCard] = []
## IDs of all cards considered on the top of the deck
var top_deck : Array[int] = []
## All cards in the deck
var deck : Array[IndexedCard] = []
## All cards discarded
var discard : Array[IndexedCard] = []
## All cards removed temporarily
var removed_cards : Array[IndexedCard] = []


## All valid card locations
enum CardSource {
	Hand,
	Deck,
	Discard,
	Removed,
}