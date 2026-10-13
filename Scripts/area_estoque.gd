extends ColorRect

func _can_drop_data(at_position, data):
	# print("can_drop_data -- area estoque")
	# Nao eh pra aceitar soltar blocos dentro da area de estoque!!!!
	return false

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
