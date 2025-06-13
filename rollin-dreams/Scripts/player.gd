extends CharacterBody3D

const SPEED = 5
const JUMP_VELOCITY = 5
var current_speed = SPEED  # Velocidade atual
var is_in_juice = false    # Flag para saber se está no sumo

func _physics_process(delta: float) -> void:
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
