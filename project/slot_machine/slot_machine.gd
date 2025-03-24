extends Node

signal _close_requested

enum _Symbol {
	BAR = 0, 
	CHERRY = 1, 
	SEVEN = 2, 
	BELL = 3
	}
	
var _symbol1 : int
var _symbol2 : int
var _symbol3 : int
var _active := true

@onready var _animated_handle = $AnimatedHandle
@onready var _win_animation = $WinAnimation


func _ready() -> void:
	_close_requested.connect(get_tree().root.get_node('World')._on_close_requested)


func _process(_delta: float) -> void:
	if not _active:
		return
	
	if Input.is_action_just_pressed("space"):
		_active = false
		_animated_handle.play("pull")
		await _animated_handle.animation_finished
		_animated_handle.play("return")
		$LeftAnimation.play("spin")
		await _random_start($MiddleAnimation)
		_random_start($RightAnimation)
		_spin_end()


func _random_start(player : AnimationPlayer) -> void:
	await get_tree().create_timer(randf_range(0, .5)).timeout
	player.play("spin")


func _spin_end() -> void:
	_symbol1 = _Symbol.values().pick_random()
	_symbol2 = _Symbol.values().pick_random()
	_symbol3 = _Symbol.values().pick_random()
	await _finish_spin()
	await _check_win()
	_active = true


func _finish_spin() -> void:
	await get_tree().create_timer(randf_range(1.5, 4)).timeout
	$LeftAnimation.stop()
	$SymbolStripLeft.position.y = 126 + (96 * _symbol1)
	await get_tree().create_timer(.5).timeout
	$MiddleAnimation.stop()
	$SymbolStripMiddle.position.y = 126 + (96 * _symbol2)
	
	if _symbol1 == _symbol2:
		await get_tree().create_timer(randf_range(1, 3)).timeout
	else:
		await get_tree().create_timer(randf_range(.5, 1)).timeout
	$RightAnimation.stop()
	$SymbolStripRight.position.y = 126 + (96 * _symbol3)


func _check_win() -> void:
	if _symbol1 == _symbol2 and _symbol2 == _symbol3:
		_active = false
		_win_animation.play("win")
		$WinSound.play()
		await _win_animation.animation_finished
	else:
		$LoseSound.play()


func _on_return_button_pressed() -> void:
	_close_requested.emit()
