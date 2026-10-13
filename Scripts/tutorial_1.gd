extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mao: Sprite2D = $Mao
@onready var mao_aponta: Sprite2D = $Aponta
@onready var comandos_label: Label = $Comandos
@onready var selecione_label: Label = $Selecione
@onready var apaga_label: Label = $Apaga
@onready var executa_label: Label = $Executa

@onready var disable_top_ui: Label = $DisableTopUI

var num_comandos: int = 0

func _ready() -> void:
	#disable_top_ui.visible = true
	mao.visible = true
	comandos_label.visible = true
	
	selecione_label.visible = false
	mao_aponta.visible = false
	apaga_label.visible = false
	executa_label.visible = false
	
	animation_player.play("mao-1")

func _on_area_montagem_comando_adicionado() -> void:
	num_comandos += 1
	
	if num_comandos == 4:
		mao.visible = false
		selecione_label.visible = true
		comandos_label.visible = false
	
	print(num_comandos)

func _on_avancar_comando_selecionado() -> void:
	disable_top_ui.visible = false
	selecione_label.visible = false
	
	mao_aponta.visible = true
	apaga_label.visible = true
	
	animation_player.play("aponta-1")

func _on_apagar_1_pressed() -> void:
	apaga_label.visible = false
	
	animation_player.stop()
	animation_player.play("aponta-2")
	
	executa_label.visible = true

func _on_executar_pressed() -> void:
	mao_aponta.visible = false
	executa_label.visible = false
