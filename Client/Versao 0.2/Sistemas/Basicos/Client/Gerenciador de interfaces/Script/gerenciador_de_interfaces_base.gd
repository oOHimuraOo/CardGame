class_name GERENCIADOR_DE_INTERFACES_BASE
extends GERENCIADOR_DE_INTERFACES_REFERENCIAS

func desativar_interface_de_abertura() -> void:
	if interface_de_abertura.is_visible_in_tree():
		interface_de_abertura.hide()
		interface_principal.carregar_informacoes()
		interface_principal.show()
