class_name INTERFACE_DO_SERVIDOR_BASE
extends INTERFACE_DO_SERVIDOR_REFERENCIAS

var porta:int = 16261

func _ready():
	iniciar_server()
	print("server iniciado!")

func iniciar_server() -> void:
	var peer:MultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(porta)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(quando_peer_conectar)
	multiplayer.peer_disconnected.connect(quando_peer_desconectar)

func quando_peer_conectar(peer_id:int) -> void:
	print("peer: ", peer_id, " conectou!")

func quando_peer_desconectar(peer_id:int) -> void:
	print("peer: ", peer_id, " desconectou!")

@rpc("any_peer","reliable")
func client_server_autenticar_usuario(usuario:String, senha:String, verificador:bool, id:int) -> void:
	iniciando.autenticar_usuario_e_senha(usuario, senha, verificador, id)

@rpc("authority", "reliable")
func servidor_client_usuario_autenticado(autenticado:bool, verificador:bool, id:int, usuario:String = "", senha:String = "") -> void:
	if usuario != "" && senha != "":
		rpc_id(id, "servidor_client_usuario_autenticado", autenticado, verificador, usuario, senha)
		return
	rpc_id(id, "servidor_client_usuario_autenticado", autenticado, verificador)

@rpc("any_peer","reliable")
func client_server_criar_usuario(usuario:String, senha:String, email:String, nick:String, id:int) -> void:
	iniciando.criar_usuario(usuario, senha, email, nick, id)

@rpc("authority","reliable")
func servidor_client_sucesso_ao_criar_cadastro(id:int) -> void:
	rpc_id(id, "servidor_client_sucesso_ao_criar_cadastro")

@rpc("authority","reliable")
func servidor_client_falha_ao_criar_cadastro(id:int) -> void:
	rpc_id(id, "servidor_client_falha_ao_criar_cadastro")

@rpc("any_peer","reliable")
func client_server_solcitar_informacao_do_jogador(id:int,usuario:String) -> void:
	enviando.coletar_informacao_do_jogador(id, usuario)

@rpc("authority", "reliable")
func servidor_client_enviar_informacao_do_jogador(id:int, account_info:Dictionary) -> void:
	rpc_id(id, "servidor_client_enviar_informacao_do_jogador", account_info)

@rpc("any_peer", "reliable")
func client_server_solicitar_update_de_noticias(id:int) -> void:
	enviando.coletar_informacoes_de_noticias(id)

@rpc("authority","reliable")
func servidor_client_enviar_noticias(id:int, noticias_info:Dictionary) -> void:
	rpc_id(id, "servidor_client_enviar_noticias", noticias_info)

@rpc("any_peer","reliable")
func client_server_abrir_boosters(boosters:Dictionary, usuario:String, id:int) -> void:
	enviando.abrir_booster(boosters, usuario, id)

@rpc("authority","reliable")
func servidor_client_enviar_cartas_tiradas(carta_tirada:Dictionary, id:int) -> void:
	rpc_id(id, "servidor_client_enviar_cartas_tiradas", carta_tirada)

@rpc("any_peer","reliable")
func client_server_carregar_colecao(usuario:String, id:int) -> void:
	enviando.carregar_colecao(usuario, id)

@rpc("any_peer","reliable")
func client_server_carregar_deck(id:int, usuario:String, nome_do_deck:String) -> void:
	enviando.carregar_deck(id, usuario, nome_do_deck)

@rpc("authority", "reliable")
func servidor_client_enviar_colecao(colecao:Dictionary, id:int) -> void:
	rpc_id(id, "servidor_client_enviar_colecao", colecao)

@rpc("authority", "reliable")
func servidor_client_enviar_deck(deck:Dictionary, id:int) -> void:
	rpc_id(id, "servidor_client_enviar_deck", deck)

@rpc("any_peer","reliable")
func client_server_solicitar_confirmacao_de_modificacao(deck_list:Dictionary, raca:String, client:String, id:int) -> void:
	recebendo.verificar_possibilidade_de_deck_list(deck_list, raca, client, id)

@rpc("authority", "reliable")
func servidor_client_enviar_resposta_de_validacao(id:int, validacao:bool, msg:String) -> void:
	rpc_id(id, "servidor_client_enviar_resposta_de_validacao", validacao, msg)
