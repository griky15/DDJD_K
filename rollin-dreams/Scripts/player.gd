class_name Player extends CharacterBody3D
const SPEED = 5
const JUMP_VELOCITY = 6
const FALL_LIMIT = -15
var current_speed = SPEED
var current_jump = JUMP_VELOCITY
var is_in_juice = false

func _ready():
	# Verifica a cena atual e ajusta velocidade e salto
	var current_scene = get_tree().current_scene.scene_file_path
	if current_scene == "res://Scenes/level_1.tscn":
		current_speed = 10
		current_jump = JUMP_VELOCITY
		print("Level 1 detectado - velocidade aumentada para 10!")
	elif current_scene == "res://Scenes/platform4.tscn":
		current_speed = 6
		current_jump = 8
		print("Platform 4 detectado - velocidade: 6, salto: 8!")
	else:
		current_speed = SPEED
		current_jump = JUMP_VELOCITY
	
	var mesh_instance = $MeshInstance3D
	var material = StandardMaterial3D.new()
	material.albedo_texture = load("res://Textures/red3.png")
	mesh_instance.set_surface_override_material(0, material)

func _physics_process(delta: float) -> void:
	var current_scene = get_tree().current_scene.scene_file_path
	# Verifica se o player caiu muito baixo
	if global_position.y < FALL_LIMIT && current_scene != "res://Scenes/level_1.tscn"  :
		game_over()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump - agora usa current_jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = current_jump
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()
	
	# Aplica rotação para simular o rolamento da bola
	var horizontal_velocity = Vector3(velocity.x, 0, velocity.z)
	if horizontal_velocity.length() > 0.01:
		var camera = get_viewport().get_camera_3d()
		var local_velocity = camera.global_transform.basis.inverse() * horizontal_velocity
		var rotation_axis = local_velocity.cross(Vector3.UP).normalized()
		var rotation_amount = local_velocity.length() * delta / $MeshInstance3D.scale.y
		$MeshInstance3D.rotate(rotation_axis, -rotation_amount)

func game_over():
	# Verifica se está no level_1 para decidir para onde ir
	var current_scene = get_tree().current_scene.scene_file_path
	
	if current_scene == "res://Scenes/level_1.tscn":
		print("Level 1 - Voltando para o menu!")
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	else:
		print("Game Over - Player caiu!")
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func jumpTrampoline():
	velocity.y = 1.5 * current_jump  # Agora usa current_jump
	print("Trampoline bounce!")

func enterJuice():
	is_in_juice = true
	var base_speed = 10 if get_tree().current_scene.scene_file_path == "res://Scenes/level_1.tscn" else current_speed
	current_speed = base_speed * 0.3
	print("Entrou no sumo - velocidade reduzida!")

func exitJuice():
	is_in_juice = false
	var current_scene = get_tree().current_scene.scene_file_path
	if current_scene == "res://Scenes/level_1.tscn":
		current_speed = 10
	elif current_scene == "res://Scenes/platform4.tscn":
		current_speed = 6
	else:
		current_speed = SPEED
	print("Saiu do sumo - velocidade normal!")
