extends Node3D

@export var player_path: NodePath  # Caminho do jogador
@export var show_distance: float = 5.0  # Distância de ativação do Label3D

var player: Node3D  # O jogador
var label: Label3D  # O Label3D a ser mostrado

func _ready():
	if player_path:
		player = get_node(player_path)  # Aponta para o jogador
		label = $Label3D  # Acha o nó Label3D (ajusta conforme o nome real do teu Label3D)
		label.visible = false  # Deixa o label invisível no início

func _process(delta: float):
	if player and label:
		var distance_to_player = global_position.distance_to(player.global_position)  # Distância entre o Label3D e o jogador
		
		if distance_to_player <= show_distance:
			label.visible = true  # Mostra o label se o jogador estiver perto
		else:
			label.visible = false  # Esconde o label se o jogador estiver longe
