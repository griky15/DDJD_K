extends Camera3D

@export var target: NodePath  # The player node
@export var follow_speed := 5.0  # Speed of camera position interpolation
@export var offset_distance := 8.0  # Horizontal distance from player to camera
@export var offset_height := 10.0  # Height above player
@export var mouse_sensitivity := 0.3  # Mouse sensitivity for rotation

var target_node: Node3D
var last_position: Vector3
var anchor: Node3D  # Parent Node3D for rotation
var last_move_direction := Vector3(0, 0, 1)  # Default direction (positive Z) to avoid initial null

func _ready():
	# Ensure the camera is a child of a Node3D anchor
	if get_parent() is Node3D:
		anchor = get_parent()
	else:
		push_warning("Camera3D should be a child of a Node3D for rotation control.")
		anchor = self
	
	# Resolve target node
	if target:
		target_node = get_node_or_null(target)
		if target_node and not target_node is Node3D:
			push_error("Target node must be a Node3D.")
			target_node = null
		if target_node:
			last_position = target_node.global_transform.origin

func _process(delta: float):
	if not target_node:
		return
	
	# Get the current position of the target
	var current_position = target_node.global_transform.origin
	
	# Calculate velocity (movement direction)
	var velocity = (current_position - last_position) / delta
	last_position = current_position
	
	# Update move direction only if player is moving
	if velocity.length() > 0.1:  # Threshold to avoid jitter when nearly stopped
		var move_direction = velocity.normalized()
		# Project onto XZ plane to ignore vertical movement (e.g., jumping)
		last_move_direction = Vector3(move_direction.x, 0, move_direction.z).normalized()
	
	# Calculate desired offset based on last movement direction
	var desired_offset = -last_move_direction * offset_distance
	desired_offset.y = offset_height  # Maintain height above player
	
	# Apply anchor's Y rotation to the offset
	desired_offset = desired_offset.rotated(Vector3.UP, anchor.global_rotation.y)
	
	# Smoothly move camera to desired position
	var desired_position = current_position + desired_offset
	global_transform.origin = global_transform.origin.lerp(desired_position, delta * follow_speed)
	
	# Look at the player
	look_at(current_position, Vector3.UP)

func _input(event):
	if  Input.is_action_just_released("MWU"):
		offset_distance = max(offset_distance - 0.5, 2.0)  # Min distance
	elif Input.is_action_just_released("MWD"):
		offset_distance = min(offset_distance + 0.5, 12.0)  # Max distance
