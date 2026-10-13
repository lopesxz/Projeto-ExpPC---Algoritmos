extends CanvasLayer

var mao: Sprite2D
var animation_player: AnimationPlayer

func _ready() -> void:
	mao = $Mao
	animation_player = $AnimationPlayer
	
	animation_player.play("mao-1")

func _on_area_montagem_comando_adicionado() -> void:
	mao.visible = false
