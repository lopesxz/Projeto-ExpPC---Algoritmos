extends CanvasLayer

@onready var adicione_label: Label = $AdicioneLabel
@onready var mao_aponta: Sprite2D = $Aponta
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var deslocamento_label: Label = $DeslocamentoLabel
@onready var painel_madeira: Sprite2D = $PainelMadeiraTutorial

var f: int = 0
func _ready() -> void:
	
	painel_madeira.visible = true
	mao_aponta.visible = true
	adicione_label.visible = true
	animation_player.play("aponta_virar")
	deslocamento_label.visible = false


func _on_area_montagem_comando_adicionado() -> void:
	if f == 0:
		painel_madeira.visible = false
		adicione_label.visible = false
		mao_aponta.visible = false
		animation_player.stop()
		f = 1
	elif f == 1:
		painel_madeira.visible = true
		adicione_label.visible = false
		mao_aponta.visible = true
		animation_player.stop()
		deslocamento_label.visible = true
		animation_player.play("aponta_deslocamento")
		f = 2
	elif f == 2:
		mao_aponta.visible = false
		deslocamento_label.visible = false
		animation_player.stop()
		painel_madeira.visible = false
		pass
		
	
