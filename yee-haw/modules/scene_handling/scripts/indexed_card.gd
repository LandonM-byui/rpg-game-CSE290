extends Resource
class_name IndexedCard

var id : int
var data : CardData

## Creates a new indexed card
static func Create(cid: int, cdata: CardData) -> IndexedCard:
	var ic := IndexedCard.new()
	ic.id = cid
	ic.data = cdata
	return ic