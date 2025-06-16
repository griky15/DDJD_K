extends Control
@onready var pause = $"."
var paused = false

func _ready():
	self.hide()
	get_tree().paused = false
	paused = false

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
	# Despausar imediatamente
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Mudar de cena no próximo frame
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/menu.tscn")

func _on_restart_pressed() -> void:
	# Despausar imediatamente
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Obtém o nome da cena atual
	var current_scene = get_tree().current_scene.scene_file_path
	var restart_scene = "res://Scenes/platform1.tscn"  # Padrão
	
	# Verifica qual cena está ativa e define o restart apropriado
	if current_scene == "res://Scenes/level_1.tscn":
		restart_scene = "res://Scenes/level_1.tscn"
	elif current_scene == "res://Scenes/platform2.tscn" or current_scene == "res://Scenes/platform4.tscn":
		restart_scene = "res://Scenes/platform2.tscn"
	
	# Mudar de cena no próximo frame
	get_tree().call_deferred("change_scene_to_file", restart_scene)
