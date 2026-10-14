extends CanvasLayer

@onready var adicione_label: Label = $AdicioneLabel
@onready var mao_aponta: Sprite2D = $Aponta
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	
	mao_aponta.visible = true
	adicione_label.visible = true
	animation_player.play("aponta_virar")


func _on_area_montagem_comando_adicionado() -> void:
	adicione_label.visible = false
	mao_aponta.visible = false
	animation_player.stop()
	
