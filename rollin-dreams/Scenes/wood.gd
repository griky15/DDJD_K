extends TextureButton

@onready var tween          := create_tween()
@onready var anim_player    := $"../CanvasLayer/AnimationPlayer"
@onready var clouds1        := $"../CanvasLayer/CloudTransition1"
@onready var clouds2        := $"../CanvasLayer/CloudTransition2"
@onready var clouds3        := $"../CanvasLayer/CloudTransition3"
@onready var clouds4        := $"../CanvasLayer/CloudTransition4"
@onready var texture_story  := $"../TextureStory"
@onready var canvas_layer   := $"../CanvasLayer"  # <- referência direta ao CanvasLayer

var normal_scale := Vector2(0.8, 0.8)
var hover_scale  := Vector2(0.82, 0.82)

func _ready() -> void:
	scale = normal_scale
	texture_story.hide()                     # começa invisível
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# posiciona as nuvens fora da tela
	clouds1.position = Vector2(-1774, -1018)
	clouds2.position = Vector2(-1089,   605)
	clouds3.position = Vector2( 1313,   358)
	clouds4.position = Vector2( 1539,  -927)

func _on_mouse_entered() -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", hover_scale, 0.2)

func _on_mouse_exited() -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", normal_scale, 0.2)

func _on_pressed() -> void:
	disabled = true
	anim_player.play("fade_out_with_clouds")
	await anim_player.animation_finished

	canvas_layer.hide()       # <- esconde o CanvasLayer (transição e nuvens)
	texture_story.show()      # <- mostra a imagem de história
	await get_tree().create_timer(3.0).timeout

	get_tree().call_deferred("change_scene_to_file", "res://Scenes/platform1.tscn")
