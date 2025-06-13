extends Camera3D

@export var target: NodePath  # The player (e.g., ball)
@export var follow_speed := 5.0  # Camera follow speed
@export var rotation_speed := 5.0  # Camera rotation interpolation speed
@export var offset := Vector3(0, 2, 8)  # Camera offset from the player
@export var mouse_sensitivity := 0.005  # Mouse sensitivity for camera rotation
@export var enable_mouse_control := true  # Toggle mouse-based camera rotation
@export var min_pitch := -PI / 3  # Minimum pitch angle (radians, ~ -60 degrees)
@export var max_pitch := PI / 3   # Maximum pitch angle (radians, ~ 60 degrees)

var target_node: Node3D
var camera_yaw := 0.0  # Camera's yaw angle (horizontal)
var camera_pitch := 0.0  # Camera's pitch angle (vertical)

func _ready():
	if target:
		target_node = get_node(target)
	# Capture mouse for input (optional, for mouse control)
	if enable_mouse_control:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handle mouse movement for camera rotation
	if enable_mouse_control and event is InputEventMouseMotion:
		# Update yaw and pitch based on mouse input
		camera_yaw -= event.relative.x * mouse_sensitivity
		camera_pitch -= event.relative.y * mouse_sensitivity
		# Clamp pitch to prevent flipping
		camera_pitch = clamp(camera_pitch, min_pitch, max_pitch)

func _process(delta: float):
	if not target_node:
		return

	# Calculate the desired position based on the player's rotation and offset
	var player_rotation = target_node.rotation.y
	var target_yaw = player_rotation if not enable_mouse_control else camera_yaw
	var target_rotation = Vector3(camera_pitch, target_yaw, 0)

	# Rotate the offset based on the target rotation (yaw)
	var rotated_offset = offset.rotated(Vector3.UP, target_yaw)
	var desired_position = target_node.global_transform.origin + rotated_offset

	# Smoothly interpolate the camera's position
	global_transform.origin = global_transform.origin.lerp(desired_position, delta * follow_speed)

	# Smoothly interpolate the camera's rotation
	var current_rotation = rotation
	var new_rotation = current_rotation.lerp(target_rotation, delta * rotation_speed)
	rotation = new_rotation

	# Ensure the camera always looks at the player
	look_at(target_node.global_transform.origin, Vector3.UP)

func _unhandled_input(event):
	# Optional: Toggle mouse capture with a key (e.g., ESC)
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
