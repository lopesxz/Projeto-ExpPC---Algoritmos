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

func avancar():
	raycast.target_position = direcao * (tamanho_passo * 0.8)
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		get_parent().get_node("CanvasLayer/AvisoLabel").visible = true
		get_parent().get_node("CanvasLayer/AvisoLabel/Reiniciar").visible = true
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
	
	# Envio da lista de blocos para log
	GerenciadorLog.definir_lista_blocos_tentativa(blocos_para_log)

	for item in lista_blocos:
		print("Comando recebido do bloco: ", item.nome_comando)
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
				
				get_parent().get_node("CanvasLayer/AvisoLabel").visible = true
				get_parent().get_node("CanvasLayer/AvisoLabel/Reiniciar").visible = true  
				break
				
		elif comando == "VIRAR À ESQUERDA" or comando == "VIRAR_ESQUERDA":
			virar_esquerda()
		elif comando == "VIRAR À DIREITA" or comando == "VIRAR_DIREITA":
			virar_direita()
			
		await get_tree().create_timer(0.5).timeout
		retangulo.color = cor_original

	if position.distance_to(Vector2(546, 231)) > 10:
		if bloco_com_erro == null:
			# Caso termine os blocos mas pare fora do destino (sem colisão prévia)
			GerenciadorLog.finalizar_tentativa(false)
			
			get_parent().get_node("CanvasLayer/AvisoLabel").visible = true
			get_parent().get_node("CanvasLayer/AvisoLabel/Reiniciar").visible = true
	else:
		# Sucesso absoluto no ponto verde
		GerenciadorLog.finalizar_tentativa(true)
		get_parent().get_node("CanvasLayer/SucessoLabel").visible = true
		GlobalJogo.proxima_fase()

func _on_botao_reiniciar_pressed():
	get_parent().get_node("CanvasLayer/AvisoLabel").visible = false
	get_parent().get_node("CanvasLayer/AvisoLabel/Reiniciar").visible = false
	
	if bloco_com_erro != null:
		bloco_com_erro.get_node("ColorRect").color = cor_padrao_erro
		bloco_com_erro = null 
	
	position = posicao_inicial
	direcao = Vector2.UP
	atualizar_sprite()
	
	tentativas += 1
	get_parent().get_node("InterfaceBlocos/ContadorLabel").text = "Tentativas: " + str(tentativas)
	
	# DISPARA O CRONÔMETRO AQUI: O aluno vai começar a pensar/montar a próxima tentativa!
	GerenciadorLog.reiniciar_e_continuar_cronometro()
