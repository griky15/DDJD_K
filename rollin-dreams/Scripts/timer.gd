extends Control

# Referências aos nós
@onready var timer_label = $TimerLabel
@onready var countdown_timer = $CountdownTimer

# Variável para controlar o tempo
var time_left = 40

func _ready():
	# Configura o timer para contar a cada 1 segundo
	countdown_timer.wait_time = 1.0
	countdown_timer.timeout.connect(_on_timer_timeout)
	
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
	# Substitua "res://proxima_cena.tscn" pelo caminho da sua cena
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
