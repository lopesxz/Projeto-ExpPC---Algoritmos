extends CanvasLayer

@onready var adicione_label: Label = $AdicioneLabel
@onready var mao_aponta: Sprite2D = $Aponta
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var deslocamento_label: Label = $DeslocamentoLabel

var f: int = 0
func _ready() -> void:
	
	mao_aponta.visible = true
	adicione_label.visible = true
	animation_player.play("aponta_virar")
	deslocamento_label.visible = false


func _on_area_montagem_comando_adicionado() -> void:
	if f == 0:
		adicione_label.visible = false
		mao_aponta.visible = true
		animation_player.stop()
		deslocamento_label.visible = true
		animation_player.play("aponta_deslocamento")
		f = 1
	elif f == 1:
		mao_aponta.visible = false
		deslocamento_label.visible = false
		animation_player.stop()
		f = 2
	else:
		pass
		
	
