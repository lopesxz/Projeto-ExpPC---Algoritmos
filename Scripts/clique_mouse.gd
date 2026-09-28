extends Control

@export var texto_do_bloco = "AVANÇAR"
@export var nome_comando = "AVANÇAR"
var selecionado = false
var cor_original_bloco = Color.WHITE

func _ready():
	$ColorRect/Label.text = texto_do_bloco
	cor_original_bloco = $ColorRect.color
# Essa função nativa do Godot é ativada automaticamente quando você clica e arrasta esse nó
func _get_drag_data(at_position):
	# Se o pai dele for a ListaBlocos, ele NÃO PODE ser arrastado de novo
	if get_parent().name == "ListaBlocos":
		return null
		
	# Caso contrário, faz a prévia de arraste normal da estante
	var preview = Control.new()
	var visual_bloco = ColorRect.new()
	
	if nome_comando == "AVANÇAR":
		visual_bloco.color = Color("gold")
	else:
		visual_bloco.color = Color("#FFA500") 
		
	visual_bloco.size = $ColorRect.size
	var visual_texto = Label.new()
	visual_texto.text = texto_do_bloco
	visual_texto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	visual_texto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	visual_texto.size = visual_bloco.size
	visual_texto.add_theme_color_override("font_color", Color.BLACK)
	
	visual_bloco.add_child(visual_texto)
	preview.add_child(visual_bloco)
	visual_bloco.position = -visual_bloco.size / 2 
	set_drag_preview(preview)
	
	return self
	
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Se ele está na Área de Montagem, ele interage com a seleção
		if get_parent().name == "ListaBlocos":
			
			# SE JÁ ESTÁ SELECIONADO: Clicar de novo desmarca ele (Toggle)
			if selecionado:
				desmarcar()
				if GlobalJogo.bloco_selecionado == self:
					GlobalJogo.bloco_selecionado = null
				print("Bloco desmarcado: ", texto_do_bloco)
				
			# SE NÃO ESTÁ SELECIONADO: Marca ele e desmarca os outros
			else:
				ressetar_selecao_geral() # Limpa os outros
				
				selecionado = true
				$ColorRect.self_modulate = Color.from_rgba8(159, 143, 117, 255) # Azul de destaque
				
				GlobalJogo.bloco_selecionado = self
				print("Bloco selecionado: ", texto_do_bloco)

# Função auxiliar para desmarcar os outros blocos da lista
func ressetar_selecao_geral():
	for irmao in get_parent().get_children():
		# Verifica se o irmão tem o método e garante que não é o próprio bloco atual
		if irmao != self and irmao.has_method("desmarcar"):
			irmao.desmarcar()

func desmarcar():
	selecionado = false
	# Garante que este bloco específico volta para a cor original dele (seja amarelo, laranja, etc.)
	$ColorRect.self_modulate = Color(1, 1, 1)
