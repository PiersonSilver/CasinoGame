extends Node

signal _close_requested

enum _Outcome {
	HEADS = 0,
	TAILS = 1 
	}

@onready var _result_label = $ResultLabel
@onready var _coin_sprite = $CoinSprite
@onready var _options = $Options


func _ready() -> void:
	_close_requested.connect(get_tree().root.get_node('World')._on_close_requested)


func _on_heads_button_pressed() -> void:
	_flip_coin('heads')


func _on_tails_button_pressed() -> void:
	_flip_coin('tails')


func _flip_coin(guess: String) -> void:
	_options.visible = false
	_result_label.visible = false
	var outcome = _Outcome.values().pick_random()
	$AudioStreamPlayer.play()
	match outcome:
		0:
			_coin_sprite.play("heads")
			if guess == 'heads':
				_result_label.text = "YOU WIN!"
			else:
				_result_label.text = "YOU LOSE"
		1:
			_coin_sprite.play("tails")
			if guess == 'tails':
				_result_label.text = "YOU WIN!"
			else:
				_result_label.text = "YOU LOSE"


func _on_coin_sprite_animation_finished() -> void:
	_options.visible = true
	_result_label.visible = true


func _on_return_button_pressed() -> void:
	_close_requested.emit()
