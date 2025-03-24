extends RigidBody2D


func _ready() -> void:
	$AnimatedSprite2D.frame = randi_range(0,29)


func _on_sleeping_state_changed() -> void:
	queue_free()
