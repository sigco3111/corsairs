## Colonial trade goods catalog.
extends RefCounted

const TYPES := {
	"provisions": {"name": "식량", "base_price": 5},
	"rum": {"name": "럼주", "base_price": 20},
	"wine": {"name": "와인", "base_price": 28},
	"sailcloth": {"name": "돛천", "base_price": 15},
	"planks": {"name": "목재", "base_price": 10},
	"gunpowder": {"name": "화약", "base_price": 25},
	"weapons": {"name": "무기", "base_price": 60},
	"medicines": {"name": "의약품", "base_price": 45},
	"silk": {"name": "비단", "base_price": 90},
	"coffee": {"name": "커피", "base_price": 50},
	"tobacco": {"name": "담배", "base_price": 40},
	"sugar": {"name": "설탕", "base_price": 18},
	"cocoa": {"name": "코코아", "base_price": 55},
	"cotton": {"name": "목화", "base_price": 22},
	"ebony": {"name": "흑단", "base_price": 75},
	"spices": {"name": "향신료", "base_price": 85},
}

static func get_type(id: String) -> Dictionary:
	assert(TYPES.has(id), "알 수 없는 교역품: %s" % id)
	return TYPES[id]

static func all_ids() -> Array:
	return TYPES.keys()
