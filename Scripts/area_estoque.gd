extends ColorRect

func _can_drop_data(at_position, data):
	# 1. Garante que o data existe e é um nó válido
	if not data is Node:
		return false
	
	# 2. Garante estritamente que ele veio de dentro da AreaEstoque
	if data.get_parent().name != "AreaEstoque":
		return false
		
	# 3. Garante que possui a propriedade de comando do bloco
	if not "nome_comando" in data:
		return false
		
	return true

func _drop_data(at_position, data):
	var lista = get_tree().current_scene.find_child("ListaBlocos", true, false)
	var aviso_limite = get_tree().current_scene.find_child("LimiteLabel", true, false)
	
	if not lista:
		return
	
	# Trava de segurança de 14 blocos
	if lista.get_child_count() >= 14:
		if aviso_limite:
			aviso_limite.visible = true
		return

	# Se passou pela triagem, duplica e adiciona com segurança
	if data and data is Node and data.get_parent().name == "AreaEstoque":
		var bloco_final = data.duplicate()
		lista.add_child(bloco_final)
		if aviso_limite:
			aviso_limite.visible = false

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var pai = get_parent()
		var aviso_limite = get_tree().current_scene.get_node("CanvasLayer/LimiteLabel")

		# Se a peça clicada já estiver na montagem: APAGA
		if pai.name == "ListaBlocos":
			queue_free()
			aviso_limite.visible = false
			return
			
		# IMPORTANTE: Se o clique foi no fundo cinza da estante (self), ignora totalmente!
		if self == get_viewport().gui_get_focus_owner() or event.position:
			# Garante que só clona se o alvo direto tiver a propriedade de comando
			if not "nome_comando" in self:
				return

		# Se a peça clicada estiver no estoque (clique direto para clonar):
		var lista = get_tree().current_scene.find_child("ListaBlocos", true, false)
		if lista:
			if lista.get_child_count() < 14:
				var clone = self.duplicate()
				lista.add_child(clone)
				aviso_limite.visible = false
			else:
				aviso_limite.visible = true
