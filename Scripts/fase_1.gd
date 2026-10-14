extends CanvasLayer

@onready var apagar_tudo_label: Label = $ApagarTudoLabel
@onready var muito_bem_label: Label = $MuitoBemLabel
@onready var mao_aponta: Sprite2D = $Aponta
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	var bloco_avancar: Control = get_tree().current_scene.find_child("Avancar")
	var area_montagem: ColorRect = get_tree().current_scene.find_child("AreaMontagem")
	
	# Encher de blocos pro aluno apagar :)
	for i in range(14):
		area_montagem.adicionar_bloco(bloco_avancar.duplicate())
	
	mao_aponta.visible = true
	apagar_tudo_label.visible = true
	muito_bem_label.visible = false
	
	animation_player.play("aponta_apagartudo")

func _on_area_montagem_comando_adicionado() -> void:
	muito_bem_label.visible = false

func _on_botao_sim_pressed() -> void:
	apagar_tudo_label.visible = false
	mao_aponta.visible = false
	muito_bem_label.visible = true
	animation_player.stop()
