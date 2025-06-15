extends Node3D
@export var value: int =1

func _on_area_3d_body_entered(body):
	if body is Player:
		GameController.candy_collected(value)
		self.queue_free()
	
