extends ColorRect
signal passos_prontos(lista)

# 1. Garante que só aceita blocos válidos do estoque (mata o clique fantasma)
func _can_drop_data(at_position, data):
	if data and "nome_comando" in data:
		return true
	return false

func _drop_data(at_position, data):
	var lista = $ListaBlocos
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
	
	var personagem = get_tree().current_scene.find_child("Byte (Personagem)", true, false)
	if not personagem:
		personagem = get_tree().get_first_node_in_group("jogador")
	
	if GlobalJogo.bloco_selecionado and is_instance_valid(GlobalJogo.bloco_selecionado):
		if GlobalJogo.bloco_selecionado.has_method("desmarcar"):
			GlobalJogo.bloco_selecionado.desmarcar()
		else:
			GlobalJogo.bloco_selecionado.color = GlobalJogo.bloco_selecionado.cor_original
		GlobalJogo.bloco_selecionado = null

	for bloco in $ListaBlocos.get_children():
		if "nome_comando" in bloco:
			lista_blocos.append(bloco)
			blocos_para_log.append(bloco.nome_comando)
		
	if lista_blocos.size() > 14:
		if aviso_limite:
			aviso_limite.visible = true
			aviso_limite.add_theme_color_override("font_color", Color.WHITE)
		return
		
	if aviso_limite:
		aviso_limite.visible = false
		
	GerenciadorLog.definir_lista_blocos_tentativa(blocos_para_log)
	emit_signal("passos_prontos", lista_blocos)
	
	if personagem:
		if personagem.has_method("_on_area_montagem_passos_prontos"):
			personagem._on_area_montagem_passos_prontos(lista_blocos)

func _on_apagar_1_pressed():
	var aviso_selecione = get_tree().current_scene.find_child("SelecioneLabel", true, false)
	if GlobalJogo.bloco_selecionado and is_instance_valid(GlobalJogo.bloco_selecionado):
		aviso_selecione.visible = false
		GerenciadorLog.registrar_clique_botao("apagar_1")
		GlobalJogo.bloco_selecionado.queue_free()
		GlobalJogo.bloco_selecionado = null
	else:
		aviso_selecione.visible = true
		await get_tree().create_timer(2.5).timeout
		aviso_selecione.visible = false
			
	var aviso_limite = get_tree().current_scene.find_child("LimiteLabel", true, false)
	if aviso_limite:
		aviso_limite.visible = false
		
func _on_apagar_todos_pressed():
	var painel_confirmacao = get_tree().current_scene.find_child("ConfirmacaoApagar", true, false)
	if painel_confirmacao:
		painel_confirmacao.visible = true
	GerenciadorLog.registrar_clique_botao("apagar_tudo")

func _on_seta_cima_pressed():
	if GlobalJogo.bloco_selecionado and is_instance_valid(GlobalJogo.bloco_selecionado):
		var bloco = GlobalJogo.bloco_selecionado
		var lista = bloco.get_parent()
		if lista and lista.name == "ListaBlocos":
			var indice_atual = bloco.get_index()
			if indice_atual > 0:
				lista.move_child(bloco, indice_atual - 1)
				GerenciadorLog.registrar_clique_botao("cima")
	else:
		var aviso_selecione = get_tree().current_scene.find_child("SelecioneLabel", true, false)
		aviso_selecione.visible = true
		await get_tree().create_timer(2.5).timeout
		aviso_selecione.visible = false

func _on_seta_baixo_pressed():
	if GlobalJogo.bloco_selecionado and is_instance_valid(GlobalJogo.bloco_selecionado):
		var bloco = GlobalJogo.bloco_selecionado
		var lista = bloco.get_parent()
		if lista and lista.name == "ListaBlocos":
			var indice_atual = bloco.get_index()
			var total_filhos = lista.get_child_count()
			if indice_atual < total_filhos - 1:
				lista.move_child(bloco, indice_atual + 1)
				GerenciadorLog.registrar_clique_botao("baixo")

func _on_botao_sim_pressed():
	var lista = get_tree().current_scene.find_child("ListaBlocos", true, false)
	if lista:
		for bloco in lista.get_children():
			bloco.queue_free()
			
	GlobalJogo.bloco_selecionado = null
	
	var aviso_limite = get_tree().current_scene.find_child("LimiteLabel", true, false)
	if aviso_limite:
		aviso_limite.visible = false
		
	var painel_confirmacao = get_tree().current_scene.find_child("ConfirmacaoApagar", true, false)
	if painel_confirmacao:
		painel_confirmacao.visible = false

func _on_botao_nao_pressed():
	var painel_confirmacao = get_tree().current_scene.find_child("ConfirmacaoApagar", true, false)
	if painel_confirmacao:
		painel_confirmacao.visible = false
