extends Camera3D

@export var target: NodePath  # O jogador (bola)
@export var follow_speed := 5.0  # A velocidade de seguimento da câmera
@export var offset := Vector3(0, 2, 8)  # Distância da câmera em relação ao jogador

var target_node: Node3D

func _ready():
	if target:
		target_node = get_node(target)

func _process(delta: float):
	if target_node:
		# Posição desejada da câmera com o offset
		var desired_position = target_node.global_transform.origin + offset
		
		# Move a câmera suavemente em direção à posição desejada
		global_transform.origin = global_transform.origin.lerp(desired_position, delta * follow_speed)
		
		# Faz a câmera olhar para o jogador
		look_at(target_node.global_transform.origin, Vector3.UP)

		# Rotaciona a câmera conforme a rotação do jogador
		# Aqui estamos usando a rotação Y do jogador para ajustar a rotação da câmera
		var player_rotation = target_node.rotation.y
		rotation = Vector3(0, player_rotation, 0)
