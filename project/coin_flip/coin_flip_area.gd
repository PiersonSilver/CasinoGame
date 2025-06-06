extends Area2D

signal _gamble_area_entered(game: String)
signal _gamble_area_exited
signal _coin_flip_requested

var _in_area := false


func _ready() -> void:
	_gamble_area_entered.connect(get_tree().root.get_node('World')._on_gamble_area_entered)
	_gamble_area_exited.connect(get_tree().root.get_node('World')._on_gamble_area_exited)
	_coin_flip_requested.connect(get_tree().root.get_node('World')._on_coin_flip_requested)



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and _in_area:
		_coin_flip_requested.emit()


func _on_body_entered(_body: Node2D) -> void:
	_gamble_area_entered.emit("COIN FLIP!")
	_in_area = true


func _on_body_exited(_body: Node2D) -> void:
	_gamble_area_exited.emit()
	_in_area = false
