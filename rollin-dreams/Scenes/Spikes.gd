extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.has_method("jumpTrampoline"):
		$SpikeEventEmitter.play()
		await get_tree().create_timer(0.1).timeout  # Wait 1.7 seconds
		body.game_over()
