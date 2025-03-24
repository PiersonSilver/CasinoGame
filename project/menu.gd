extends Control


func _on_credit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world/world.tscn")
