extends StaticBody3D

@export var jump_impulse = 100.0
@export var player: Node3D
@export var inner_mesh_path: NodePath = "BounceArea/InnerMesh"
@export var area_path: NodePath = "BounceArea"
var is_pulsing = false
var pulse_scale = 1.0
var pulse_speed = 5.0
var pulse_amount = 0.1
var pulse_timer = 0.0
var pulse_duration = 1.0

func _ready():
	var area = get_node(area_path)
	area.body_entered.connect(_on_body_entered)
	var mesh = get_node_or_null(inner_mesh_path)
	if mesh:
		mesh.scale = Vector3(1, 1, 1)

func _on_body_entered(body):
	print("entered")
	print("entered")
	is_pulsing = true
	pulse_timer = pulse_duration
	if player:
		print(player)
		player.jumpTrampoline()
	var mesh = get_node_or_null(inner_mesh_path)

func _physics_process(delta):
	var mesh = get_node_or_null(inner_mesh_path)
	if is_pulsing and mesh:
		pulse_timer -= delta
		if pulse_timer <= 0.0:
			is_pulsing = false
			mesh.scale = Vector3(1, 1, 1)
		pulse_scale = 1.0 + sin(Time.get_ticks_msec() * 0.01 * pulse_speed) * pulse_amount
		var xz_scale = 1.0 + pulse_scale * 0.5
		mesh.scale = Vector3(xz_scale, pulse_scale, xz_scale)
