extends Area2D

var _in_area := false

@onready var _label = $Label


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and _in_area:
		get_tree().change_scene_to_file("res://menu.tscn")


func _on_body_entered(_body: Node2D) -> void:
	_in_area = true
	_label.visible = true


func _on_body_exited(_body: Node2D) -> void:
	_in_area = false
	_label.visible = false
