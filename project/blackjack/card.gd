class_name Card
extends Node2D

const _SPRITE_PADDING_H : int = 1
const _SPRITE_PADDING_W : int = 4
const _SPRITE_HEIGHT : int = 168
const _SPRITE_WIDTH : int = 122
const _CARD_HEIGHT : int = 144
const _CARD_WIDTH :int = 100
var card_value : int

@onready var _all_cards = $AllCards
@onready var _card_back = $CardBack


func set_card_value(suit: int, card: int, is_hidden: bool) -> void:
	_all_cards.region_rect = Rect2(_SPRITE_PADDING_W + (_SPRITE_WIDTH * card), _SPRITE_PADDING_H + (_SPRITE_HEIGHT * suit), _CARD_WIDTH, _CARD_HEIGHT)
	if is_hidden:
		_card_back.visible = true
		_all_cards.visible = false
	if card >= 9:
		card_value = 10
	elif card == 0:
		card_value = 11
	else:
		card_value = card + 1


func show_hidden() -> void:
	_all_cards.visible = true
	_card_back.visible = false


func check_ace() -> bool:
	if card_value == 11:
		return true
	else:
		return false
