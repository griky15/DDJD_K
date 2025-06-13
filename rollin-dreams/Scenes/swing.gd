extends Node3D

# Physics parameters
var angular_velocity: float = 0.0  # Current angular velocity (radians/sec)
var angular_acceleration: float = 0.0  # Angular acceleration
var gravity: float = 9.8  # Gravity constant
var length: float = 2.0  # Length of strings (meters, adjust based on your setup)
var damping: float = 0.98  # Damping factor to simulate air resistance
var max_angle: float = deg_to_rad(45.0)  # Max swing angle (45 degrees)

# Input force for pushing the swing
var push_force: float = 2.0  # Force applied when pushing (adjust for strength)

func _ready():
	# Ensure the swing starts at rest
	angular_velocity = 0.0

func _physics_process(delta):
	# Calculate pendulum motion (simple harmonic motion approximation)
	var angle = rotation.x  # Current rotation around X-axis (side-to-side swing)
	
	# Pendulum equation: angular_acc = - (g / L) * sin(theta)
	angular_acceleration = -(gravity / length) * sin(angle)
	
	# Update angular velocity
	angular_velocity += angular_acceleration * delta
	angular_velocity *= damping  # Apply damping to simulate air resistance
	
	# Update rotation
	rotation.x += angular_velocity * delta
	
	# Clamp rotation to prevent excessive swinging
	rotation.x = clamp(rotation.x, -max_angle, max_angle)
	
	# Handle user input to push the swing
	if Input.is_action_just_pressed("push_swing"):
		angular_velocity += push_force / length  # Apply an impulse to swing
