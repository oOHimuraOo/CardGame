class_name POP_UP_INTERFACE
extends Control

@onready var etiqueta_texto = $PlanoDeFundo/Marginalizador/OrganizadorMiolo/EtiquetaTexto

var sucesso: bool = false
var construtor_de_deck: bool = false

func mudar_texto_do_pop_up(texto:String, suc:bool, construtor:bool = false) -> void:
	sucesso = suc
	construtor_de_deck = construtor
	etiqueta_texto.set_text(texto)

func _on_botao_ok_pressed():
	if !construtor_de_deck:
		var interface_de_abertura = get_tree().get_first_node_in_group("Client").find_child("InterfaceDeAbertura")
		if sucesso:
			interface_de_abertura.cadastro_finalizado(interface_de_abertura.coletor_usuario_criar.get_text())
		interface_de_abertura.limpar_campos_criar()
		get_tree().paused = false
		queue_free()
	else:
		var construtor = get_tree().get_first_node_in_group("Construtor")
		if !sucesso:
			get_tree().paused = false
			queue_free()
			return
		construtor.fechar_pagina()
		get_tree().paused = false
		queue_free()
