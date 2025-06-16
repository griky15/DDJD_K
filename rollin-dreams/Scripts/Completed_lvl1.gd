extends CanvasLayer

func _ready():
	# Força o cursor a ficar visível
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/platform2.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
