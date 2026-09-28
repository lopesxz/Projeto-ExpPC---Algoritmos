extends ColorRect
signal passos_prontos(lista)

# 1. Garante que só aceita blocos válidos do estoque (mata o clique fantasma)
func _can_drop_data(at_position, data):
	if data and "nome_comando" in data:
		return true
	return false

func _drop_data(at_position, data):
	var lista = $ListaBlocos
	# Procura o aviso de limite automaticamente na cena inteira
	var aviso_limite = get_tree().current_scene.find_child("LimiteLabel", true, false)
	
	if lista.get_child_count() >= 14:
		if aviso_limite:
			aviso_limite.visible = true
		return

	if data and "nome_comando" in data:
		var bloco_final = data.duplicate()
		lista.add_child(bloco_final)
		if aviso_limite:
			aviso_limite.visible = false


func _on_executar_pressed():
	var lista_blocos = []
	var aviso_limite = get_tree().current_scene.find_child("LimiteLabel", true, false)
	var blocos_para_log = []
	
	# Se houver algum bloco selecionado na hora que clica em executar, desmarca ele
	if GlobalJogo.bloco_selecionado and is_instance_valid(GlobalJogo.bloco_selecionado):
		# Se o seu bloco tem uma função de desmarcar interna, chame-a:
		if GlobalJogo.bloco_selecionado.has_method("desmarcar"):
			GlobalJogo.bloco_selecionado.desmarcar()
		else:
			# Ou force a cor original de volta caso não tenha a função pronta
			GlobalJogo.bloco_selecionado.color = GlobalJogo.bloco_selecionado.cor_original # (Ajuste o nome da variável de cor se necessário)
			
		GlobalJogo.bloco_selecionado = null

	for bloco in $ListaBlocos.get_children():
		if "nome_comando" in bloco:
			lista_blocos.append(bloco)
			# ADICIONA O NOME DO COMANDO NA LISTA PARA O LOG:
			blocos_para_log.append(bloco.nome_comando)
		
			
	# Trava se passar de 14 blocos na hora de executar
	if lista_blocos.size() > 14:
		if aviso_limite:
			aviso_limite.visible = true
			aviso_limite.add_theme_color_override("font_color", Color.WHITE)
		return
		
	if aviso_limite:
		aviso_limite.visible = false
		
	# Envia a lista inteira de uma vez para o GerenciadorLog registrar na tentativa atual
	GerenciadorLog.definir_lista_blocos_tentativa(blocos_para_log)
	print("Comandos a executar: ", lista_blocos)
	emit_signal("passos_prontos", lista_blocos)
	
	


func _on_apagar_1_pressed():
	var aviso_selecione = get_tree().current_scene.find_child("SelecioneLabel", true, false)
	if GlobalJogo.bloco_selecionado and is_instance_valid(GlobalJogo.bloco_selecionado):
		aviso_selecione.visible = false
		# REGISTRO NO LOG:
		GerenciadorLog.registrar_clique_botao("apagar_1")
		# -------------------------
		GlobalJogo.bloco_selecionado.queue_free()
		GlobalJogo.bloco_selecionado = null
	else:
		aviso_selecione.visible = true
		await get_tree().create_timer(2.5).timeout
		aviso_selecione.visible = false
			
		
	# Procura o aviso de limite e desliga ele, pois agora abriu espaço
	var aviso_limite = get_tree().current_scene.find_child("LimiteLabel", true, false)
	if aviso_limite:
		aviso_limite.visible = false
		
func _on_apagar_todos_pressed():
	var painel_confirmacao = get_tree().current_scene.find_child("ConfirmacaoApagar", true, false)
	if painel_confirmacao:
		painel_confirmacao.visible = true # Mostra o painel na tela
	# REGISTRO NO LOG:
	GerenciadorLog.registrar_clique_botao("apagar_tudo")
	


func _on_seta_cima_pressed():
# Verifica se há um bloco selecionado e se ele é válido
	if GlobalJogo.bloco_selecionado and is_instance_valid(GlobalJogo.bloco_selecionado):
		var bloco = GlobalJogo.bloco_selecionado
		var lista = bloco.get_parent() # A "ListaBlocos" onde eles estão encaixados
		
		# Confirma que o bloco realmente pertence à área de montagem
		if lista and lista.name == "ListaBlocos":
			var indice_atual = bloco.get_index()
			
			# Se ele não for o primeiro da lista, dá para subir
			if indice_atual > 0:
				lista.move_child(bloco, indice_atual - 1)
				# REGISTRO NO LOG (Soma automaticamente no bloco de uso_setas):
				GerenciadorLog.registrar_clique_botao("cima")
	else:
		var aviso_selecione = get_tree().current_scene.find_child("SelecioneLabel", true, false)
		aviso_selecione.visible = true
		await get_tree().create_timer(2.5).timeout
		aviso_selecione.visible = false


func _on_seta_baixo_pressed():
# Verifica se há um bloco selecionado e se ele é válido
	if GlobalJogo.bloco_selecionado and is_instance_valid(GlobalJogo.bloco_selecionado):
		var bloco = GlobalJogo.bloco_selecionado
		var lista = bloco.get_parent() # A "ListaBlocos"
		
		# Confirma que o bloco pertence à área de montagem
		if lista and lista.name == "ListaBlocos":
			var indice_atual = bloco.get_index()
			var total_filhos = lista.get_child_count()
			
			# Se ele não for o último da lista, dá para descer
			if indice_atual < total_filhos - 1:
				lista.move_child(bloco, indice_atual + 1)
				# REGISTRO NO LOG (Soma automaticamente no bloco de uso_setas):
				GerenciadorLog.registrar_clique_botao("baixo")
				


func _on_botao_sim_pressed():
	var lista = get_tree().current_scene.find_child("ListaBlocos", true, false)
	if lista:
		for bloco in lista.get_children():
			bloco.queue_free() # Apaga todos os blocos
			
	GlobalJogo.bloco_selecionado = null
	
	var aviso_limite = get_tree().current_scene.find_child("LimiteLabel", true, false)
	if aviso_limite:
		aviso_limite.visible = false
		
	var painel_confirmacao = get_tree().current_scene.find_child("ConfirmacaoApagar", true, false)
	if painel_confirmacao:
		painel_confirmacao.visible = false # Esconde o painel de novo


func _on_botao_nao_pressed():
	var painel_confirmacao = get_tree().current_scene.find_child("ConfirmacaoApagar", true, false)
	if painel_confirmacao:
		painel_confirmacao.visible = false # Apenas esconde o painel sem apagar nada
