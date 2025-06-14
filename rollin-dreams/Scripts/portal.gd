extends StaticBody3D

@export var target_scene: PackedScene
@export var player: Node3D
@export var inner_mesh_path: NodePath = "InnerPortalArea/InnerPortalMesh"
@export var area_path: NodePath = "InnerPortalArea"
@export var sound_emitter_path: NodePath = "PortalSoundEmitter"  # Path to FmodEventEmitter3D

func _ready():
	var sound_emitter = get_node_or_null(sound_emitter_path)
	if not sound_emitter:
		push_warning("FmodEventEmitter3D not found at: ", sound_emitter_path)
	var area = get_node_or_null(area_path)
	if area and area is Area3D:
		print("Area3D found: ", area.name)
		area.body_entered.connect(_on_body_entered)
	else:
		push_error("Invalid Area3D at path: %s" % area_path)
	

func _on_body_entered(body: Node):
	if body == player and target_scene:
		var sound_emitter = get_node_or_null(sound_emitter_path)
		if sound_emitter:
			$PortalSoundEmitter.play()
			sound_emitter.play()  # Use play() to start the event
		else:
			push_warning("FmodEventEmitter3D not found at: ", sound_emitter_path)
		print("Body Entered Portal")
		print("Can instantiate: ", target_scene.can_instantiate())
		print("Scene state: ", target_scene.get_state())
		await get_tree().create_timer(2).timeout  # Wait 1.7 seconds
		get_tree().call_deferred("change_scene_to_packed", target_scene)
	else:
		if body != player:
			print("Body %s is not the player" % body.name)
		if not target_scene:
			push_warning("Target scene not set for portal")
