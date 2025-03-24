extends CharacterBody2D

const _SPEED = 75.0
const _RATE := 0.4

var active := true

@onready var _animated_sprite = $AnimatedSprite2D


func _physics_process(_delta):
	if not active:
		return
	
	var direction = _get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * _SPEED, _RATE)
	else:
		velocity = velocity.lerp(Vector2.ZERO, _RATE)
	move_and_slide()
	_update_animation(direction)
	

func _get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input


func _update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		_animated_sprite.play('idle')
	elif direction.x > 0:
		_animated_sprite.play('right')
	elif direction.x < 0:
		_animated_sprite.play('left')
	elif direction.y > 0:
		_animated_sprite.play('down')
	elif direction.y < 0:
		_animated_sprite.play('up')
