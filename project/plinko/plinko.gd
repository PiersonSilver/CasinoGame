extends Node2D

signal _close_requested

const _LEFT = 360
const _RIGHT = 800
const _SPEED = 150
const _DELAY = .5

var _input_allowed := true
var _moving_right := true
var _plinko_ball := preload("res://plinko/plinko_ball.tscn")

@onready var _placholder_ball := $PlaceholderBall


func _ready() -> void:
	_close_requested.connect(get_tree().root.get_node('World')._on_close_requested)


func _process(delta: float) -> void:
	_move_placeholder(delta)
	if Input.is_action_just_pressed('space') and _input_allowed:
		_input_allowed = false
		var ball = _plinko_ball.instantiate()
		ball.global_position = _placholder_ball.global_position
		add_child(ball)
		await get_tree().create_timer(_DELAY).timeout
		_input_allowed = true


func _move_placeholder(delta: float) -> void:
	if _placholder_ball.position.x >= _RIGHT:
		_moving_right = false
	elif _placholder_ball.position.x <= _LEFT:
		_moving_right = true
	if _moving_right: 
		_placholder_ball.position.x += _SPEED * delta
	else:
		_placholder_ball.position.x -= _SPEED * delta


func _on_section_entered(value: float) -> void:
	print(value)


func _on_return_button_pressed() -> void:
	_close_requested.emit()
