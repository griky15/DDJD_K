extends Control

# Referências aos nós
@onready var timer_label = $TimerLabel
@onready var countdown_timer = $CountdownTimer

# Variável para controlar o tempo
var time_left = 40

func _ready():
	# Verifica qual cena está ativa e define o tempo inicial
	var current_scene = get_tree().current_scene.scene_file_path
	
	if current_scene == "res://Scenes/platform4.tscn":
		time_left = 90  # Começa com 30 segundos na platform4
	else:
		time_left = 60  # Tempo padrão para outras cenas
	
	# Configura o timer para contar a cada 1 segundo
	countdown_timer.wait_time = 1.0
	countdown_timer.timeout.connect(_on_timer_timeout)
	timer_label.add_theme_color_override("font_color", Color(1, 0, 0))  
	# Atualiza o label inicial
	update_timer_display()
	
	# Inicia o timer
	countdown_timer.start()

func _on_timer_timeout():
	# Diminui o tempo
	time_left -= 1
	
	# Atualiza o display
	update_timer_display()
	
	# Verifica se chegou a 0
	if time_left <= 0:
		countdown_timer.stop()
		change_scene()

func update_timer_display():
	# Atualiza o texto do label
	timer_label.text = str(time_left)

func change_scene():
	# Muda para a próxima cena
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
