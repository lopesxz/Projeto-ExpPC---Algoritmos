extends VBoxContainer

# Bloco "REPITA X VEZES": guarda outros blocos dentro dele e o Byte executa eles X vezes
@export var texto_do_bloco = "REPITA"
@export var nome_comando = "REPITA"
var selecionado = false
const LIMITE_BLOCOS = 14
signal comando_selecionado

@onready var cabecalho = $ColorRect
@onready var campo_vezes = $ColorRect/HBox/Vezes
@onready var corpo = $Corpo
@onready var lista_interna = $Corpo/ListaInterna

func _ready():
	# O cabeçalho tem que caber o texto e o número, mas nunca fica menor que os outros blocos
	cabecalho.custom_minimum_size.x = max(180, $ColorRect/HBox.get_combined_minimum_size().x + 10)

	# Na estante o número não pode ser mexido (senão atrapalha o arraste)
	var filtro = Control.MOUSE_FILTER_STOP if esta_na_montagem() else Control.MOUSE_FILTER_IGNORE
	campo_vezes.mouse_filter = filtro
	campo_vezes.get_line_edit().mouse_filter = filtro

	if not lista_interna.child_order_changed.is_connected(_atualizar_corpo):
		lista_interna.child_order_changed.connect(_atualizar_corpo)
	_atualizar_corpo()

func esta_na_montagem():
	return get_parent() != null and get_parent().name == "ListaBlocos"

func obter_vezes():
	campo_vezes.apply()
	return int(campo_vezes.value)

func get_lista_comandos():
	var lista_comandos = {
		"bloco": nome_comando,
		"num_reps": obter_vezes(),
		"comandos": obter_nome_blocos()
	}
	
	return lista_comandos

# Retorna os blocos que estão dentro do repita (na ordem em que aparecem)
func obter_blocos():
	var blocos = []
	for bloco in lista_interna.get_children():
		if "nome_comando" in bloco and not bloco.is_queued_for_deletion():
			blocos.append(bloco)
	return blocos

func obter_nome_blocos():
	var blocos = obter_blocos()
	var nome_blocos = []
	for b in blocos:
		nome_blocos.append(b.nome_comando)
	return nome_blocos

# Sem blocos dentro, o repita fica do tamanho dos outros. Com blocos, ele cresce.
func _atualizar_corpo():
	if is_instance_valid(corpo):
		corpo.visible = obter_blocos().size() > 0

func _get_drag_data(at_position):
	# Se ele já está na Área de Montagem, NÃO PODE ser arrastado de novo
	if esta_na_montagem():
		return null

	var preview = Control.new()
	var visual_bloco = ColorRect.new()
	visual_bloco.color = cabecalho.color
	visual_bloco.size = cabecalho.size

	var visual_texto = Label.new()
	visual_texto.text = "REPITA " + str(int(campo_vezes.value)) + " VEZES"
	visual_texto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	visual_texto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	visual_texto.size = visual_bloco.size
	visual_texto.add_theme_color_override("font_color", Color.WHITE)

	visual_bloco.add_child(visual_texto)
	preview.add_child(visual_bloco)
	visual_bloco.position = -visual_bloco.size / 2
	set_drag_preview(preview)

	return self

# Aceita blocos soltos em cima do repita (só quando ele está na Área de Montagem)
func _can_drop_data(at_position, data):
	if not esta_na_montagem():
		return false
	if data and "nome_comando" in data:
		return true
	return false

func _drop_data(at_position, data):
	var area_montagem = get_tree().current_scene.find_child("AreaMontagem", true, false)
	var aviso_limite = get_tree().current_scene.find_child("LimiteLabel", true, false)

	# Não dá pra colocar um repita dentro de outro: ele vai pro fim da montagem
	if data.nome_comando == "REPITA":
		if area_montagem:
			area_montagem.adicionar_bloco(data)
		return

	if area_montagem and area_montagem.contar_blocos() >= LIMITE_BLOCOS:
		if aviso_limite:
			aviso_limite.visible = true
		return

	var bloco_final = data.duplicate()
	lista_interna.add_child(bloco_final)
	if aviso_limite:
		aviso_limite.visible = false
	if area_montagem:
		area_montagem.comando_adicionado.emit()
 
func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not esta_na_montagem():
			return

		# SE JÁ ESTÁ SELECIONADO: Clicar de novo desmarca ele (Toggle)
		if selecionado:
			desmarcar()
			if GlobalJogo.bloco_selecionado == self:
				GlobalJogo.bloco_selecionado = null

		# SE NÃO ESTÁ SELECIONADO: Marca ele e desmarca os outros
		else:
			ressetar_selecao_geral()

			selecionado = true
			cabecalho.self_modulate = Color.from_rgba8(159, 143, 117, 255)
			corpo.self_modulate = Color.from_rgba8(159, 143, 117, 255)
			comando_selecionado.emit()
			GlobalJogo.bloco_selecionado = self

func ressetar_selecao_geral():
	for irmao in get_parent().get_children():
		if irmao != self and irmao.has_method("desmarcar"):
			irmao.desmarcar()
	# O bloco selecionado pode estar dentro de algum repita
	if GlobalJogo.bloco_selecionado and is_instance_valid(GlobalJogo.bloco_selecionado) and GlobalJogo.bloco_selecionado != self:
		if GlobalJogo.bloco_selecionado.has_method("desmarcar"):
			GlobalJogo.bloco_selecionado.desmarcar()

func desmarcar():
	selecionado = false
	cabecalho.self_modulate = Color(1, 1, 1)
	corpo.self_modulate = Color(1, 1, 1)
