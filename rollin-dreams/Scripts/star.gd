extends Node3D
@export var value: int =1
func _on_area_3d_body_entered(body):
	if body is Player:
		$CandySoundEmitter.play()
		await get_tree().create_timer(0.45).timeout  
		GameController.candy_collected(value)
		self.queue_free()


	
