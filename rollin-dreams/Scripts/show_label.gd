extends Node3D

@export var player_path: NodePath  # Path to the player node
@export var label_path: NodePath   # Path to the Label3D node
@export var show_distance: float = 50.0  # Distance to activate the Label3D

var player: Node3D  # Reference to the player
var label: Label3D  # Reference to the Label3D

func _ready():
	# Get the player node
	if player_path:
		player = get_node(player_path)
		if not player:
			print("Player node not found at path: ", player_path)
			return
	
	# Get the Label3D node
	if label_path:
		label = get_node(label_path)
		if not label:
			print("Label3D node not found at path: ", label_path)
			return
		label.visible = false  # Hide the label initially
	else:
		print("Label3D path not set.")

func _process(delta: float):
	if player and label:
		# Calculate distance between this node's global position and the player's global position
		var distance_to_player = global_position.distance_to(player.global_position)
		
		# Show or hide the label based on distance
		label.visible = distance_to_player <= show_distance
