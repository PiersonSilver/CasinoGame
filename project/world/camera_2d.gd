extends Camera2D

@export var _target : Node2D


func _ready() -> void:
	global_position = _target.global_position


func _physics_process(delta: float) -> void:
	global_position.y = lerp(global_position.y, clampf(_target.global_position.y, 170, 820), 1*delta)
	global_position.x = lerp(global_position.x, clampf(_target.global_position.x, 300, 850), 1*delta)
