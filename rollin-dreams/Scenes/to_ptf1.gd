# res://Scripts/button_menu.gd
extends TextureButton

## --- PARÂMETROS EDITÁVEIS NO INSPECTOR -----------------
@export var target_scene_path : String  = "res://Scenes/level_1.tscn"
@export var normal_scale      : Vector2 = Vector2(0.4,  0.4)
@export var hover_scale       : Vector2 = Vector2(0.41, 0.41)
@export var tween_time        : float  = 0.2
## --------------------------------------------------------

@onready var tween        := create_tween()
@onready var anim_player  := $"../CanvasLayer/AnimationPlayer"
@onready var clouds1      := $"../CanvasLayer/CloudTransition1"
@onready var clouds2      := $"../CanvasLayer/CloudTransition2"
@onready var clouds3      := $"../CanvasLayer/CloudTransition3"
@onready var clouds4      := $"../CanvasLayer/CloudTransition4"

func _ready() -> void:
	scale = normal_scale
	# posiciona as nuvens fora da tela (igual ao script original)
	clouds1.position = Vector2(-1774, -1018)
	clouds2.position = Vector2(-1089,  605)
	clouds3.position = Vector2( 1313,   358)
	clouds4.position = Vector2( 1539,  -927)

func _on_mouse_entered() -> void:
	_animate_scale(hover_scale)

func _on_mouse_exited() -> void:
	_animate_scale(normal_scale)

func _on_pressed() -> void:
	disabled = true                       # evita cliques múltiplos
	anim_player.play("fade_out_with_clouds")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(target_scene_path)

# --------------------------------------------------------
func _animate_scale(target : Vector2) -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", target, tween_time)
