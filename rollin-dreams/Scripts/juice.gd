extends Area3D

extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.has_method("enterJuice"):
		body.enterJuice()

func _on_body_exited(body):
	if body.has_method("exitJuice"):
		body.exitJuice()
