extends Area2D

signal _section_entered(value : float)

@export var _value : float
@export var _display : String

@onready var color_area := $ColorRect

func _ready() -> void:
	$Label.text = _display + 'x'
	_section_entered.connect(get_parent().get_parent()._on_section_entered)
	match _value:
		.1:
			color_area.color = Color.RED
		.25:
			color_area.color = Color.ORANGE_RED
		.5:
			color_area.color = Color.ORANGE
		2.0:
			color_area.color = Color.YELLOW
		5.0:
			color_area.color = Color.GREEN_YELLOW
		25.0:
			color_area.color = Color.GREEN


func _on_body_entered(body: Node2D) -> void:
	_section_entered.emit(_value)
	body.queue_free()
	$AnimationPlayer.play("entered")
	$AudioStreamPlayer2D.play()
