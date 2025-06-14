extends Area3D
@export var sound_emitter_path: NodePath = "GrassSoundEmitter"  # Path to FmodEventEmitter3D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	var sound_emitter = get_node_or_null(sound_emitter_path)
	if not sound_emitter:
		push_warning("FmodEventEmitter3D not found at: ", sound_emitter_path)

func _on_body_entered(body):
	if body.has_method("enterJuice"):
		var sound_emitter = get_node_or_null(sound_emitter_path)
		if sound_emitter:
			$GrassSoundEmitter.play()
			sound_emitter.play()  # Use play() to start the event
		else:
			push_warning("FmodEventEmitter3D not found at: ", sound_emitter_path)

func _on_body_exited(body):
	if body.has_method("exitJuice"):
		$GrassSoundEmitter.stop()
