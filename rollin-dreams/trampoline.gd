extends Area3D

@export var jump_impulse = 100.0
@export var inner_mesh: NodePath
var is_pulsing = false
var pulse_scale = 1.0
var pulse_speed = 5.0
var pulse_amount = 0.1
var pulse_timer = 0.0
var pulse_duration = 1.0

func _ready():
	self.body_entered.connect(self._on_body_entered)
	if inner_mesh:
		var mesh = get_node(inner_mesh)
		mesh.scale = Vector3(1, 1, 1)

func _on_body_entered(body):
	if body is RigidBody3D:
		body.apply_central_impulse(Vector3.UP * jump_impulse)
		is_pulsing = true
		pulse_timer = pulse_duration
		if inner_mesh and get_node(inner_mesh).material is ShaderMaterial:
			get_node(inner_mesh).material.set_shader_parameter("pulse_intensity", 1.0)

func _physics_process(delta):
	if is_pulsing and inner_mesh:
		var mesh = get_node(inner_mesh)
		pulse_timer -= delta
		if pulse_timer <= 0.0:
			is_pulsing = false
			mesh.scale = Vector3(1, 1, 1)
			if mesh.material is ShaderMaterial:
				mesh.material.set_shader_parameter("pulse_intensity", 0.0)
		pulse_scale = 1.0 + sin(Time.get_ticks_msec() * 0.01 * pulse_speed) * pulse_amount
		var xz_scale = 1.0 + pulse_scale * 0.5
		mesh.scale = Vector3(xz_scale, pulse_scale, xz_scale)
