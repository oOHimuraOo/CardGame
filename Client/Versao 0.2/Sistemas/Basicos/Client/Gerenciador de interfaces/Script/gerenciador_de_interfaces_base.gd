class_name GERENCIADOR_DE_INTERFACES_BASE
extends GERENCIADOR_DE_INTERFACES_REFERENCIAS

func desativar_interface_de_abertura() -> void:
	if interface_de_abertura.is_visible_in_tree():
		interface_de_abertura.hide()
		interface_principal.carregar_informacoes()
		interface_principal.show()

func desativar_interface_principal(em_partida:bool) -> void:
	if interface_principal.is_visible_in_tree():
		if em_partida:
			interface_principal.hide()
			interface_de_abertura.hide()
			interface_em_partida.show()
			interface_em_partida.esperar_jogadores_prontos()
		else:
			interface_principal.hide()
			interface_de_abertura.show()
			interface_em_partida.hide()
