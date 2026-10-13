extends Node

var bloco_selecionado = null

# Função para avançar automaticamente para a fase seguinte
func proxima_fase() -> void:
	var objetivo_nodes = get_tree().get_nodes_in_group("objetivo_group")

	if objetivo_nodes.size() > 0:
		var scene: PackedScene = objetivo_nodes[0].next_scene
		
		if scene:
			get_tree().change_scene_to_packed(scene)
		else:
			print("Fim das fases! A voltar ao menu principal...")
			get_tree().change_scene_to_file("res://Cenas/menu_principal.tscn")
	else:
		print("Nao ha nodo objetivo!!s")
