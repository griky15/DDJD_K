extends Area3D
@export var sound_emitter_path: NodePath = "WoodSoundEmitter"  # Path to FmodEventEmitter3D
@export var movement_threshold: float = 0.1  # Minimum velocity to consider as "moving"

var player_in_area: CharacterBody3D = null
var sound_emitter = null
var is_sound_playing: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	var sound_emitter = get_node_or_null(sound_emitter_path)
	sound_emitter = get_node_or_null(sound_emitter_path)
	if not sound_emitter:
		push_warning("FmodEventEmitter3D not found at: ", sound_emitter_path)

func _process(_delta):
	# Check if player is in area and monitor their movement
	if player_in_area:
		check_player_movement()

func _on_body_entered(body):
	if body.has_method("enterJuice"):
		var sound_emitter = get_node_or_null(sound_emitter_path)
		if sound_emitter:
			$WoodSoundEmitter.play()
			sound_emitter.play()  # Use play() to start the event
		else:
			push_warning("FmodEventEmitter3D not found at: ", sound_emitter_path)
		player_in_area = body
		print("Player entered wood area")

func _on_body_exited(body):
	if body.has_method("exitJuice"):
		$WoodSoundEmitter.stop()
		player_in_area = null
		stop_sound()
		print("Player exited wood area")

func check_player_movement():
	if not player_in_area:
		return
	
	# Get horizontal velocity (ignore Y component for jumping)
	var horizontal_velocity = Vector3(player_in_area.velocity.x, 0, player_in_area.velocity.z)
	var is_moving = horizontal_velocity.length() > movement_threshold
	
	# Only play sound if player is moving and on the floor
	var should_play_sound = is_moving and player_in_area.is_on_floor()
	
	if should_play_sound and not is_sound_playing:
		play_sound()
	elif not should_play_sound and is_sound_playing:
		stop_sound()

func play_sound():
	if sound_emitter:
		sound_emitter.play()
		is_sound_playing = true
		print("Wood sound started")
	else:
		push_warning("FmodEventEmitter3D not found at: ", sound_emitter_path)

func stop_sound():
	if sound_emitter:
		sound_emitter.stop()
	is_sound_playing = false
	print("Wood sound stopped")
