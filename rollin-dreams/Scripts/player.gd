class_name Player extends CharacterBody3D

const SPEED = 5
const JUMP_VELOCITY = 5
const FALL_LIMIT = -10  # Limite de queda para game over

var current_speed = SPEED  # Velocidade atual
var is_in_juice = false    # Flag para saber se está no sumo

func _physics_process(delta: float) -> void:
	# Verifica se o player caiu muito baixo
	if global_position.y < FALL_LIMIT:
		game_over()
		return  # Para o processamento para evitar bugs
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
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

func game_over():
	# Muda para a cena de game over
	print("Game Over - Player caiu!")
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func jumpTrampoline():
	velocity.y = 1.5 * JUMP_VELOCITY
	print("Trampoline bounce!")

# Funções para o sumo
func enterJuice():
	is_in_juice = true
	current_speed = SPEED * 0.3  # Reduz para 30% da velocidade
	print("Entrou no sumo - velocidade reduzida!")

func exitJuice():
	is_in_juice = false
	current_speed = SPEED  # Volta à velocidade normal
	print("Saiu do sumo - velocidade normal!")
