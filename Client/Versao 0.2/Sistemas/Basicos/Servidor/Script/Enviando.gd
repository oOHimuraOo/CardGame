class_name ENVIANDO
extends Node

func autenticar_usuario(usuario:String, senha:String, verificador:bool) -> void:
	SERVER.client_server_autenticar_usuario(usuario, senha, verificador)

func criar_usuario(usuario:String, senha:String, email:String, nick:String) -> void:
	SERVER.client_server_criar_usuario(usuario, senha, email, nick)

func solicitar_informacao_de_jogador_pro_server(usuario:String) -> void:
	SERVER.client_server_solcitar_informacao_do_jogador(usuario)

func solicitiar_update_de_noticias_ao_servidor() -> void:
	SERVER.client_server_solicitar_update_de_noticias()

func solicitar_abertura_de_booster(boosters:Dictionary) -> void:
	var client = get_tree().get_first_node_in_group("Client").name
	SERVER.client_server_abrir_boosters(boosters, client)

func solicitar_colecao_ao_servidor() -> void:
	var client = get_tree().get_first_node_in_group("Client").name
	SERVER.client_server_carregar_colecao(client)

func solicitar_deck_ao_servidor(nome_do_deck:String) -> void:
	var client = get_tree().get_first_node_in_group("Client").name
	SERVER.client_server_carregar_deck(client, nome_do_deck)

func deck_modificado(deck_list: Dictionary, raca:String) -> void:
	var client = get_tree().get_first_node_in_group("Client").name
	SERVER.client_server_solicitar_confirmacao_de_modificacao(deck_list, raca, client)
