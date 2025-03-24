extends Node

signal _close_requested

enum _Suit {
	DIAMOND = 0, 
	HEART = 1,
	CLUB = 2, 
	SPADE = 3
	}
	
enum _Value {
	ACE = 0, 
	TWO = 1, 
	THREE = 2, 
	FOUR = 3, 
	FIVE = 4, 
	SIX = 5, 
	SEVEN = 6, 
	EIGHT = 7, 
	NINE = 8, 
	TEN = 9, 
	JACK = 10, 
	QUEEN = 11, 
	KING = 12
	}
	
enum _EndOption {
	PLAYER_BUST,
	PLAYER_BLACKJACK,
	DEALER_BLACKJACK,
	DEALER_WIN,
	PLAYER_WIN,
	DEALER_BUST,
	PUSH
}

var _center_x : int = 572
var _card_width : int = 100

var _player : _Participant
var _dealer : _Participant

@onready var _hit_button = $HitButton
@onready var _stand_button = $StandButton
@onready var _player_label = $Player
@onready var _dealer_label = $Dealer
@onready var _play_button = $PlayButton
@onready var _end_game_label = $EndGameLabel


func _ready() -> void:
	_close_requested.connect(get_tree().root.get_node('World')._on_close_requested)


func _newGame() -> void:
	_reset_game()
	_player = _Player.new()
	_player.y = 440
	_dealer = _Dealer.new()
	_dealer.y = 200
	
	
	_player.card1 = await add_card(_player, false)
	_player.card1.position.x = _center_x - (_card_width/2.0)

	_dealer.card1 = await add_card(_dealer, true)
	_dealer.card1.position.x = _center_x + (_card_width/2.0)

	_player.card2 = await add_card(_player, false)
	_player.card2.position.x = _center_x + (_card_width/2.0)
	
	_dealer.card2 = await add_card(_dealer, false)
	_dealer.card2.position.x = _center_x - (_card_width/2.0)

	if _player.score == 21 and _player.score == _dealer.score:
		_end_game(_EndOption.PUSH)
		return
		
	elif _dealer.score == 21:
		_end_game(_EndOption.DEALER_BLACKJACK)
		return
		
	elif _player.score == 21:
		_end_game(_EndOption.PLAYER_BLACKJACK)
		return
	
	_hit_button.visible = true
	_hit_button.disabled = false
	_stand_button.visible = true


func add_card(reciever : _Participant, is_hidden : bool) -> Card:
	$AudioStreamPlayer.play()
	await get_tree().create_timer(.5).timeout
	var card = preload("res://blackjack/card.tscn").instantiate()
	add_child(card)
	card.set_card_value(_Suit.values().pick_random(), _Value.values().pick_random(), is_hidden)
	if reciever.score + card.card_value > 21 and card.card_value == 11:
		reciever.score += 1
	elif reciever.score + card.card_value > 21 and reciever.ace:
		reciever.score -= 10
		reciever.score += card.card_value
		reciever.ace = false
	elif card.card_value == 11:
		reciever.score += card.card_value
		reciever.ace = true
	else:
		reciever.score += card.card_value
	reciever.card_count += 1
	card.position.y = reciever.y
	if reciever == _player:
		_player_label.text = "PLAYER: " + str(_player.score)
	return card


func _on_play_button_pressed() -> void:
	_newGame()


func _on_stand_button_pressed() -> void:
	_dealer_turn()


func _dealer_turn() -> void:
	_dealer_label.text = "DEALER: " + str(_dealer.score)
	_hit_button.disabled = true
	_dealer.card1.show_hidden()
	while _dealer.score < 17:
		if _dealer.new_card == null:
			_dealer.new_card = await add_card(_dealer, false)
			_dealer.card2.position.x = _center_x - (_card_width)
			_dealer.card1.position.x = _center_x
			_dealer.new_card.position.x = _center_x + (_card_width)
		else:
			_dealer.new_card = await add_card(_dealer, false)
			_dealer.new_card.position.x = _center_x + _card_width + (_card_width) * (_dealer.card_count - 3)  
		_dealer_label.text = "DEALER: " + str(_dealer.score)

	if _dealer.score > 21:
		_end_game(_EndOption.DEALER_BUST)
		return

	elif _dealer.score > _player.score:
		_end_game(_EndOption.DEALER_WIN)
		return
	
	elif _dealer.score < _player.score:
		_end_game(_EndOption.PLAYER_WIN)
		return

	elif _dealer.score == _player.score:
		_end_game(_EndOption.PUSH)
		return


func _on_hit_button_pressed() -> void:
	if _player.new_card == null:
		_player.new_card = await add_card(_player, false)
		_player.card1.position.x = _center_x - (_card_width)
		_player.card2.position.x = _center_x
		_player.new_card.position.x = _center_x + (_card_width)
	else:
		_player.new_card = await add_card(_player, false)
		_player.new_card.position.x = _center_x + _card_width + (_card_width) * (_player.card_count - 3) 
	
	if _player.score > 21:
		_end_game(_EndOption.PLAYER_BUST)
		return
	
	elif _player.score == 21:
		_dealer_turn()

func _end_game(condition : _EndOption) -> void:
	_hit_button.visible = false
	_stand_button.visible = false
	if condition == _EndOption.PLAYER_BUST:
		_dealer.card1.show_hidden()
		_end_game_label.text = "YOU BUSTED. YOU LOSE"
	elif condition == _EndOption.DEALER_BUST:
		_end_game_label.text = "DEALER BUSTED. YOU WIN"
	elif condition == _EndOption.PLAYER_WIN:
		_end_game_label.text = "YOU WIN"
	elif condition == _EndOption.DEALER_WIN:
		_end_game_label.text = "YOU LOSE"
	elif condition == _EndOption.PLAYER_BLACKJACK:
		_end_game_label.text = "BLACKJACK!!! YOU WIN!"
	elif condition == _EndOption.DEALER_BLACKJACK:
		_dealer.card1.show_hidden()
		_end_game_label.text = "DEALER BLACKJACK... TOUGH LUCK"
	elif _EndOption.PUSH:
		_end_game_label.text = "PUSH"
		
	_play_button.visible = true


func _reset_game() -> void:
	var cards = get_tree().get_nodes_in_group("cards")
	for card in cards:
		card.call_deferred("queue_free")

	_play_button.visible = false
	_dealer_label.visible = true
	_player_label.visible = true
	_end_game_label.text = ""
	_dealer_label.text = "DEALER"
	_player_label.text = "PLAYER"
	

class _Participant:
	var ace := false
	var score := 0
	var card_count := 0.0
	var card1 : Node2D
	var card2 : Node2D
	var new_card : Node2D
	var y : int

class _Dealer extends _Participant:
	pass
	
	
class _Player extends _Participant:
	pass


func _on_return_button_pressed() -> void:
	_close_requested.emit()
