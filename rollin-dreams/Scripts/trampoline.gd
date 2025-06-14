extends StaticBody3D

@export var jump_impulse = 100.0
@export var player: Node3D
@export var inner_mesh_path: NodePath = "BounceArea/InnerMesh"
@export var area_path: NodePath = "BounceArea"
@export var sound_emitter_path: NodePath = "TrampolineSoundEmitter"  # Path to FmodEventEmitter3D
var is_tremoring = false
var tremor_timer = 0.0
var tremor_duration = 0.5  # Duration of the tremor effect
var tremor_intensity = 0.05  # Maximum displacement for the tremor
var original_position: Vector3

func _ready():
	var area = get_node(area_path)
	area.body_entered.connect(_on_body_entered)
	var mesh = get_node_or_null(inner_mesh_path)
	if mesh:
		mesh.scale = Vector3(1, 1, 1)
		original_position = mesh.position  # Store the original position
	# Verify sound emitter
	var sound_emitter = get_node_or_null(sound_emitter_path)
	if not sound_emitter:
		push_warning("FmodEventEmitter3D not found at: ", sound_emitter_path)

func _on_body_entered(body):
	print("entered")
	is_tremoring = true
	tremor_timer = tremor_duration
	if player:
		print(player)
		player.jumpTrampoline()
	# Play FMOD sound
	var sound_emitter = get_node_or_null(sound_emitter_path)
	if sound_emitter:
		$TrampolineSoundEmitter.play()
		sound_emitter.play()  # Use play() to start the event
	else:
		push_warning("FmodEventEmitter3D not found at: ", sound_emitter_path)

func _physics_process(delta):
	var mesh = get_node_or_null(inner_mesh_path)
	if is_tremoring and mesh:
		tremor_timer -= delta
		if tremor_timer <= 0.0:
			is_tremoring = false
			mesh.position = original_position  # Reset to original position
		else:
			# Apply random tremor offset
			var offset = Vector3(
				randf_range(-tremor_intensity, tremor_intensity),
				randf_range(-tremor_intensity, tremor_intensity),
				randf_range(-tremor_intensity, tremor_intensity)
			)
			mesh.position = original_position + offset
