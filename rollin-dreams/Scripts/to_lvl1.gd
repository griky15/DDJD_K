extends TextureButton

@onready var tween := create_tween()
@onready var anim_player := $"../CanvasLayer/AnimationPlayer"
@onready var clouds1 := $"../CanvasLayer/CloudTransition1"
@onready var clouds2 := $"../CanvasLayer/CloudTransition2"
@onready var clouds3 := $"../CanvasLayer/CloudTransition3"
@onready var clouds4 := $"../CanvasLayer/CloudTransition4"

var normal_scale := Vector2(0.8, 0.8)
var hover_scale := Vector2(0.82, 0.82)

func _ready():
	scale = normal_scale
	clouds1.position = Vector2(-1774, -1018) 
	clouds2.position = Vector2(-1089, 605) 
	clouds3.position = Vector2(1313, 358) 
	clouds4.position = Vector2(1539, -927) 

func _on_mouse_entered():
	tween.kill() # Encerra tween anterior se tiver
	tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, 0.2)

func _on_mouse_exited():
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", normal_scale, 0.2)

func _on_pressed() -> void:
	disabled = true  # Evita apertar o botão de novo
	anim_player.play("fade_out_with_clouds")  # Nome da sua animação

	await anim_player.animation_finished  # Espera a animação terminar

	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
