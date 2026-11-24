extends Node2D
@onready var painel_madeira: Sprite2D = $InterfaceBlocos/Tutorial/PainelMadeiraTutorial
@onready var disable_top_ui: Label = $InterfaceBlocos/Tutorial/DisableTopUI #BLOQUEIO DOS COMANDOS DE CIMA
@onready var disable_top_ui2: Label = $InterfaceBlocos/Tutorial/DisableTopUI2 #BLOQUEIO DA AREA DE ESTOQUE
@onready var mao_aponta: Sprite2D = $InterfaceBlocos/Tutorial/Aponta
@onready var animation_player: AnimationPlayer = $InterfaceBlocos/Tutorial/AnimationPlayer
@onready var novo_comando_label: Label = $InterfaceBlocos/Tutorial/NovoComandoLabel
@onready var usando_ele_label: Label = $InterfaceBlocos/Tutorial/UsandoEleLabel
@onready var arraste_label: Label = $InterfaceBlocos/Tutorial/ArrasteLabel
@onready var adicione_label: Label = $InterfaceBlocos/Tutorial/AdicioneLabel
@onready var defina_qtd_label: Label = $InterfaceBlocos/Tutorial/DefinaQtdLabel
@onready var muito_bem_label: Label = $InterfaceBlocos/Tutorial/MuitoBemLabel
@onready var botao_proximo: Button = $InterfaceBlocos/Tutorial/BotaoProximo
@onready var imagem_proximo: Sprite2D = $InterfaceBlocos/Tutorial/ImagemProximoMadeira
var f: int = 0

func _ready() -> void:
	f = 0
	disable_top_ui.visible = true
	disable_top_ui2.visible = true 
	painel_madeira.visible = true
	novo_comando_label.visible = true
	imagem_proximo.visible = true
	botao_proximo.visible = true
	

func _on_botao_proximo_pressed() -> void:
	novo_comando_label.visible = false
	usando_ele_label.visible = true
	f = 1
	if f == 1:
		usando_ele_label.visible = false
		arraste_label.visible = true
		disable_top_ui2.visible = false 
		# ANIMAÇÃO MAO APONTANDO PRO REPITA = TRUE
		imagem_proximo.visible = false
		botao_proximo.visible = false
		f = 2
func _on_comando_adicionado():
	if f == 2:
		arraste_label.visible = false
		adicione_label.visible = true
		botao_proximo.visible = false
		imagem_proximo.visible = false
