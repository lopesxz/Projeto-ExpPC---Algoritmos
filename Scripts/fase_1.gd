extends CanvasLayer
@onready var area_montagem: ColorRect = $InterfaceBlocos/Control/AreaMontagem
@onready var avancar: Control = $InterfaceBlocos/Control/AreaEstoque/Avancar
@onready var apagar_tudo: Label = $ApagarTudoLabel
@onready var mao_aponta: Sprite2D = $InterfaceBlocos/Tutorial/Aponta
@onready var disable_top_ui: Label = $InterfaceBlocos/Tutorial/DisableTopUI
@onready var animation_player: AnimationPlayer = $InterfaceBlocos/Tutorial/AnimationPlayer

var f = 0 # flag pra detectar se ele ainda ta no tutorial

func _ready() -> void:
	apagar_tudo.visible = true
	animation_player.play("aponta_apagartudo")

	for i in range(14):
		area_montagem.adicionar_bloco(avancar.duplicate())
		
func _on_apagar_todos_pressed() -> void:
		apagar_tudo.visible = false
		animation_player.stop()
