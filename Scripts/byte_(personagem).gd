extends Node2D

var tamanho_passo = 64
var direcao = Vector2.UP
var posicao_inicial = Vector2.ZERO
var tentativas = 0
var bloco_com_erro = null
var cor_padrao_erro = null
var tempo_segundos = 0

@onready var sprite = $Sprite2D
@onready var raycast = $RayCast2D

func _ready():
	posicao_inicial = position
	sprite.region_enabled = true
	atualizar_sprite()
	
	# Conecta o botão de reiniciar automaticamente ao iniciar a fase de forma segura
	var btn_reiniciar = _obter_ui("Reiniciar")
	if btn_reiniciar and not btn_reiniciar.pressed.is_connected(_on_botao_reiniciar_pressed):
		btn_reiniciar.pressed.connect(_on_botao_reiniciar_pressed)

# Função auxiliar universal que encontra os nós em qualquer nível da árvore (inclusive dentro do CanvasLayer reposicionado)
func _obter_ui(nome: String):
	return get_tree().current_scene.find_child(nome, true, false)

func avancar():
	raycast.target_position = direcao * (tamanho_passo * 0.8)
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var aviso = _obter_ui("AvisoLabel")
		var botao = _obter_ui("Reiniciar")
		if aviso: aviso.visible = true
		if botao: botao.visible = true
		return false
	else:
		position += direcao * tamanho_passo
		return true

func virar_direita():
	if direcao == Vector2.RIGHT: direcao = Vector2.DOWN
	elif direcao == Vector2.DOWN: direcao = Vector2.LEFT
	elif direcao == Vector2.LEFT: direcao = Vector2.UP
	elif direcao == Vector2.UP: direcao = Vector2.RIGHT
	atualizar_sprite()

func virar_esquerda():
	if direcao == Vector2.RIGHT: direcao = Vector2.UP
	elif direcao == Vector2.UP: direcao = Vector2.LEFT
	elif direcao == Vector2.LEFT: direcao = Vector2.DOWN
	elif direcao == Vector2.DOWN: direcao = Vector2.RIGHT
	atualizar_sprite()

func atualizar_sprite():
	if direcao == Vector2.RIGHT:
		sprite.region_rect = Rect2(136, 392, 48, 48) 
	elif direcao == Vector2.LEFT:
		sprite.region_rect = Rect2(200, 392, 48, 48)
	elif direcao == Vector2.UP:
		sprite.region_rect = Rect2(200, 328, 48, 48)
	elif direcao == Vector2.DOWN:
		sprite.region_rect = Rect2(8, 264, 48, 48)

# --------------------------------------------------------------------
# FUNÇÃO PRA MEXER NA SETINHA DO TECLADO --> TIRAR APÓS A FINALIZAÇÃO!!!!
# --------------------------------------------------------------------
func _input(event):
	if event.is_action_pressed("ui_up"):
		avancar()
	elif event.is_action_pressed("ui_right"):
		virar_direita()
	elif event.is_action_pressed("ui_left"):
		virar_esquerda()
# --------------------------------------------------------------------

func _on_area_montagem_passos_prontos(lista_blocos):
	var blocos_para_log = []
	for item in lista_blocos:
		if item is Node and "nome_comando" in item:
			blocos_para_log.append(item.nome_comando)
	
	GerenciadorLog.definir_lista_blocos_tentativa(blocos_para_log)

	for item in lista_blocos:
		var comando = ""
		var retangulo = null
		
		if item is Node:
			comando = item.nome_comando
			retangulo = item.get_node("ColorRect")
		elif item is String:
			comando = item
			continue
		else:
			continue
			
		var cor_original = retangulo.color
		
		retangulo.color = Color.WEB_GRAY 
		await get_tree().create_timer(0.3).timeout 
		
		if comando == "AVANÇAR":
			var passo_ok = avancar()
			if passo_ok == false:
				bloco_com_erro = item
				cor_padrao_erro = cor_original
				
				GerenciadorLog.finalizar_tentativa(false)
				
				var aviso = _obter_ui("AvisoLabel")
				var botao = _obter_ui("Reiniciar")
				if aviso: aviso.visible = true
				if botao: botao.visible = true
				break
				
		elif comando == "VIRAR À ESQUERDA" or comando == "VIRAR_ESQUERDA":
			virar_esquerda()
		elif comando == "VIRAR À DIREITA" or comando == "VIRAR_DIREITA":
			virar_direita()
			
		await get_tree().create_timer(0.5).timeout
		retangulo.color = cor_original

	if position.distance_to(Vector2(546, 231)) > 10:
		if bloco_com_erro == null:
			GerenciadorLog.finalizar_tentativa(false)
			var aviso = _obter_ui("AvisoLabel")
			var botao = _obter_ui("Reiniciar")
			if aviso: aviso.visible = true
			if botao: botao.visible = true
	else:
		var sucesso = _obter_ui("SucessoLabel")
		GerenciadorLog.finalizar_tentativa(true)
		if sucesso: sucesso.visible = true
		GlobalJogo.proxima_fase()

func _on_botao_reiniciar_pressed():
	var aviso_label = _obter_ui("AvisoLabel")
	var sucesso_label = _obter_ui("SucessoLabel")
	var botao_reiniciar = _obter_ui("Reiniciar")
	var contador_label = _obter_ui("ContadorLabel")
	
	if aviso_label: aviso_label.visible = false
	if sucesso_label: sucesso_label.visible = false
	if botao_reiniciar: botao_reiniciar.visible = false
	
	if bloco_com_erro != null:
		if bloco_com_erro.has_node("ColorRect"):
			bloco_com_erro.get_node("ColorRect").color = cor_padrao_erro
		bloco_com_erro = null 
	
	position = posicao_inicial
	direcao = Vector2.UP
	atualizar_sprite()
	
	tentativas += 1
	if contador_label:
		contador_label.text = "Tentativas: " + str(tentativas)
	
	GerenciadorLog.reiniciar_e_continuar_cronometro()
