extends Node2D

var _slot_machine_scene := preload("res://slot_machine/slot_machine.tscn")
var _black_jack_scene := preload("res://blackjack/blackjack.tscn")
var _plinko_scene := preload("res://plinko/plinko.tscn")
var _coin_flip_scene := preload("res://coin_flip/coin_flip.tscn")

@onready var _game_container = $GameLayer/GameContainer
@onready var _player = $Player
@onready var _play_label = $Camera2D/PlayLabel

func _on_gamble_area_entered(game: String) -> void:
	_play_label.visible = true
	_play_label.text = "Press 'E' to Play!\n" + game
	
	
func _on_gamble_area_exited() -> void:
	_play_label.visible = false


func _on_slot_requested() -> void:
	var _slot_machine = _slot_machine_scene.instantiate()
	_game_container.add_child(_slot_machine)
	_player.active = false


func _on_black_jack_requested() -> void:
	var _black_jack = _black_jack_scene.instantiate()
	_game_container.add_child(_black_jack)
	_player.active = false


func _on_plinko_requested() -> void:
	var _plinko = _plinko_scene.instantiate()
	_game_container.add_child(_plinko)
	_player.active = false


func _on_coin_flip_requested() -> void:
	var _coin_flip = _coin_flip_scene.instantiate()
	_game_container.add_child(_coin_flip)
	_player.active = false


func _on_close_requested() -> void:
	for child in _game_container.get_children():
		child.queue_free()
	_player.active = true
