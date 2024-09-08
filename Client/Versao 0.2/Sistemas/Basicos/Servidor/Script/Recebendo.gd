class_name RECEBENDO
extends Node

func usuario_e_senha_autenticado(autenticado:bool, verificador:bool, usuario:String = "", senha:String = "") -> void:
	var client = get_tree().get_first_node_in_group("Client")
	var gerenciador_de_interface = client.find_child("GerenciadorDeInterfaces")
	if autenticado:
		if verificador:
			if usuario != "" && senha != "":
				client.name = usuario
				DATA.login_automatico(usuario, senha, verificador)
				gerenciador_de_interface.desativar_interface_de_abertura()
				gerenciador_de_interface.find_child("PaginaHome").solicitar_noticias_de_jogo_ao_servidor()
		else:
			client.name = usuario
			gerenciador_de_interface.desativar_interface_de_abertura()
			gerenciador_de_interface.find_child("PaginaHome").solicitar_noticias_de_jogo_ao_servidor()
			DATA.excluir_login_automatico()
	else:
		var interface_de_abertura = gerenciador_de_interface.find_child("InterfaceDeAbertura")
		interface_de_abertura.pop_up_de_falha_de_login()

func falha_ao_criar_cadastro() -> void:
	var interface_de_abertura = get_tree().get_first_node_in_group("Client").find_child("GerenciadorDeInterfaces").find_child("InterfaceDeAbertura")
	interface_de_abertura.pop_up_de_falha()

func sucesso_ao_criar_cadastro() -> void:
	var interface_de_abertura = get_tree().get_first_node_in_group("Client").find_child("GerenciadorDeInterfaces").find_child("InterfaceDeAbertura")
	interface_de_abertura.pop_up_de_sucesso()

func informacoes_do_jogador_recebida(account_info:Dictionary) -> void:
	var client = get_tree().get_first_node_in_group("Client")
	var gerenciador_de_interface = client.find_child("GerenciadorDeInterfaces")
	var interface_principal = gerenciador_de_interface.find_child("InterfacePrincipal")
	var interface_home = client.find_child("PaginaHome")
	interface_principal.AccountInfo = account_info
	interface_home.atualizar_barra_de_xp(account_info["exp_atual"], account_info["exp_proximo_nivel"])
	interface_principal.info_recebida.emit()

func atualizacao_de_noticias(noticias_info) -> void:
	DATA.criar_noticias(noticias_info) 

func booster_aberto(carta_tirada) -> void:
	var booster_popup = get_tree().get_first_node_in_group("booster_popup")
	booster_popup.instanciar_cartas(carta_tirada)
	
	var client = get_tree().get_first_node_in_group("Client")
	var gerenciador_de_interface = client.find_child("GerenciadorDeInterfaces")
	var interface_principal = gerenciador_de_interface.find_child("InterfacePrincipal")
	interface_principal.atualizar_informacoes()

func informacoes_da_colecao(colecao:Dictionary) -> void:
	var construtor:CONSTRUTOR_DE_DECK_BASE = get_tree().get_first_node_in_group("Construtor")
	construtor.inicializar_colecao(colecao)

func informacoes_do_deck(deck:Dictionary) -> void:
	var construtor:CONSTRUTOR_DE_DECK_BASE = get_tree().get_first_node_in_group("Construtor")
	construtor.decklist.gerar_decklist(deck)

func atualizacao_de_deck_validada(validacao:bool, msg:String) -> void:
	var construtor:CONSTRUTOR_DE_DECK_BASE = get_tree().get_first_node_in_group("Construtor")
	construtor.exibir_popup_de_confirmacao_de_validacao_de_deck(validacao, msg)

func jogador_em_fila_de_espera() -> void:
	var lobby = get_tree().get_first_node_in_group("Lobby")
	lobby.em_fila = true
	lobby.configurar_tempo_em_fila()

func jogador_saiu_da_fila_de_espera() -> void:
	var lobby = get_tree().get_first_node_in_group("Lobby")
	lobby.em_fila = false

func iniciar_partida() -> void:
	var lobby = get_tree().get_first_node_in_group("Lobby")
	lobby.sair_do_lobby(true)
