extends Node2D
@onready var painel_madeira: Sprite2D = $InterfaceBlocos/Tutorial/PainelMadeiraTutorial
@onready var disable_top_ui: Label = $InterfaceBlocos/Tutorial/DisableTopUI #BLOQUEIO DOS COMANDOS DE CIMA
@onready var disable_lower_ui_all: Label = $InterfaceBlocos/Tutorial/DisableLowerUIAll
@onready var disable_lower_ui_except_repita: Label = $InterfaceBlocos/Tutorial/DisableLowerUIExceptRepita
@onready var mao_aponta: Sprite2D = $InterfaceBlocos/Tutorial/Aponta
@onready var mao: Sprite2D = $InterfaceBlocos/Tutorial/Mao
@onready var animation_player: AnimationPlayer = $InterfaceBlocos/Tutorial/AnimationPlayer
@onready var novo_comando_label: Label = $InterfaceBlocos/Tutorial/NovoComandoLabel
@onready var usando_ele_label: Label = $InterfaceBlocos/Tutorial/UsandoEleLabel
@onready var arraste_label: Label = $InterfaceBlocos/Tutorial/ArrasteLabel
@onready var adicione_label: Label = $InterfaceBlocos/Tutorial/AdicioneLabel
@onready var defina_qtd_label: Label = $InterfaceBlocos/Tutorial/DefinaQtdLabel
@onready var muito_bem_label: Label = $InterfaceBlocos/Tutorial/MuitoBemLabel
@onready var botao_proximo: Button = $InterfaceBlocos/Tutorial/BotaoProximo
@onready var imagem_proximo: Sprite2D = $InterfaceBlocos/Tutorial/ImagemProximoMadeira

@onready var lista_blocos:VFlowContainer = $InterfaceBlocos/Control/AreaMontagem/ListaBlocos

var f: int = 0
var repita_vezes:int = 2

func _ready() -> void:
	f = 0
	disable_top_ui.visible = true
	disable_lower_ui_all.visible = true 
	
	painel_madeira.visible = true
	novo_comando_label.visible = true
	imagem_proximo.visible = true
	botao_proximo.visible = true
	
	mao.visible = false
	mao_aponta.visible = false
	
	animation_player.play("RESET")

func _on_botao_proximo_pressed() -> void:
	if f == 0:
		novo_comando_label.visible = false
		usando_ele_label.visible = true
	elif f == 1:
		usando_ele_label.visible = false
		arraste_label.visible = true
		
		imagem_proximo.visible = false
		botao_proximo.visible = false
		
		# ANIMAÇÃO MAO APONTANDO PRO REPITA = TRUE
		mao.visible = true
		animation_player.play("mao-1")
		
		# Habilita o usuario a clicar nos botoes
		disable_lower_ui_all.visible = false
		disable_lower_ui_except_repita.visible = true
	elif f == 5:
		muito_bem_label.visible = false
		
		disable_top_ui.visible = false
		disable_lower_ui_all.visible = false
		disable_lower_ui_except_repita.visible = false
		
		painel_madeira.visible = false
		imagem_proximo.visible = false
		botao_proximo.visible = false
	
	f += 1


func _on_comando_adicionado():
	if (f > 3):
		return
	
	if f == 2:
		animation_player.play("mao-2")
		
		arraste_label.visible = false
		adicione_label.visible = true
		
		botao_proximo.visible = false
		imagem_proximo.visible = false
		
		disable_lower_ui_except_repita.visible = false
	if f == 3:
		var repita: Node = null
		
		for bloco in lista_blocos.get_children():
			if bloco.nome_comando == "REPITA":
				repita = bloco
		
		if repita == null:
			return
		else:
			repita.vezes_changed.connect(_on_repita_vezes_changed)
		
		mao.visible = false
		mao_aponta.visible = true
		
		animation_player.play("aponta-1")
		
		adicione_label.visible = false
		defina_qtd_label.visible = true
	
	f += 1

func _on_repita_vezes_changed(vezes: int) -> void:
	if f == 4 and vezes == 7:
		disable_top_ui.visible = true
		disable_lower_ui_all.visible = true
		
		mao_aponta.visible = false
		animation_player.stop()
		
		defina_qtd_label.visible = false
		muito_bem_label.visible = true
		
		imagem_proximo.visible = true
		botao_proximo.visible = true
		
		f += 1
