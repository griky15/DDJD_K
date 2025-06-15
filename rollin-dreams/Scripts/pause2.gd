extends Control

@onready var pause = $"."
var paused = false

func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		pausemenu()

func _on_resume_pressed() -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused = false
		paused = false


func _on_exit_pressed() -> void:
	get_tree().quit()

func pausemenu():
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.show()
		get_tree().paused = true
	paused = !paused
	


func _on_menu_pressed() -> void:
	get_tree().paused = false
	
	# Restaurar o modo do mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Carregar a cena do menu principal
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")



func _on_restart_pressed() -> void:
	get_tree().paused = false

	# Restaurar o modo do mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Redirecionar para a cena "platform1"
	get_tree().change_scene_to_file("res://Scenes/platform1.tscn")
