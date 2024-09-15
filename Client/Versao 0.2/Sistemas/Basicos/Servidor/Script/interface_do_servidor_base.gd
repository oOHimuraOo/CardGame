class_name INTERAFACE_DO_SERVIDOR_BASE
extends INTERFACE_DO_SERVIDOR_REFERENCIAS

var id:int
var ip:String = "127.0.0.1"
var porta:int = 16261

func _ready():
	conectar_ao_server()

func conectar_ao_server() -> void:
	var peer:MultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_client(ip, porta)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(quando_conectar_ao_server)
	multiplayer.connection_failed.connect(quando_coneccao_falhar)

func quando_conectar_ao_server() -> void:
	id = multiplayer.get_unique_id()

func quando_coneccao_falhar() -> void:
	print("Falha ao conectar com o servidor!")

@rpc("any_peer","reliable")
func client_server_autenticar_usuario(usuario, senha, verificador) -> void:
	rpc_id(1, "client_server_autenticar_usuario", usuario, senha, verificador, id)

@rpc("authority", "reliable")
func servidor_client_usuario_autenticado(autenticado:bool, verificador:bool, status:String, usuario:String = "", senha:String = "") -> void:
	if usuario != "" && senha != "":
		recebendo.usuario_e_senha_autenticado(autenticado, verificador, status, usuario, senha)
		return
	recebendo.usuario_e_senha_autenticado(autenticado, verificador, status)

@rpc("any_peer","reliable")
func client_server_criar_usuario(usuario:String, senha:String, email:String, nick:String) -> void:
	rpc_id(1, "client_server_criar_usuario", usuario, senha, email, nick, id)

@rpc("authority","reliable")
func servidor_client_sucesso_ao_criar_cadastro() -> void:
	recebendo.sucesso_ao_criar_cadastro()

@rpc("authority","reliable")
func servidor_client_falha_ao_criar_cadastro() -> void:
	recebendo.falha_ao_criar_cadastro()

@rpc("any_peer","reliable")
func client_server_solcitar_informacao_do_jogador(usuario:String) -> void:
	rpc_id(1, "client_server_solcitar_informacao_do_jogador", id, usuario)

@rpc("authority","reliable")
func servidor_client_enviar_informacao_do_jogador(account_info:Dictionary) -> void:
	recebendo.informacoes_do_jogador_recebida(account_info)

@rpc("any_peer","reliable")
func client_server_solicitar_update_de_noticias() -> void:
	rpc_id(1, "client_server_solicitar_update_de_noticias", id)
	
@rpc("authority","reliable")
func servidor_client_enviar_noticias(noticias_info:Dictionary) -> void:
	recebendo.atualizacao_de_noticias(noticias_info)

@rpc("any_peer","reliable")
func client_server_abrir_boosters(boosters:Dictionary, usuario:String) -> void:
	rpc_id(1,"client_server_abrir_boosters", boosters, usuario, id)

@rpc("authority","reliable")
func servidor_client_enviar_cartas_tiradas(carta_tirada:Dictionary) -> void:
	recebendo.booster_aberto(carta_tirada)

@rpc("any_peer","reliable")
func client_server_carregar_colecao(usuario:String) -> void:
	rpc_id(1, "client_server_carregar_colecao", usuario, id)

@rpc("any_peer","reliable")
func client_server_carregar_deck(usuario:String, nome_do_deck:String) -> void:
	rpc_id(1, "client_server_carregar_deck", id, usuario, nome_do_deck)

@rpc("authority", "reliable")
func servidor_client_enviar_colecao(colecao:Dictionary) -> void:
	recebendo.informacoes_da_colecao(colecao)

@rpc("authority", "reliable")
func servidor_client_enviar_deck(deck:Dictionary) -> void:
	recebendo.informacoes_do_deck(deck)

@rpc("any_peer","reliable")
func client_server_solicitar_confirmacao_de_modificacao(deck_list:Dictionary, raca:String, client:String) -> void:
	rpc_id(1,"client_server_solicitar_confirmacao_de_modificacao", deck_list, raca, client, id)

@rpc("authority", "reliable")
func servidor_client_enviar_resposta_de_validacao(validacao:bool, msg:String) -> void:
	recebendo.atualizacao_de_deck_validada(validacao, msg)

@rpc("any_peer", "reliable")
func client_server_solicitar_entrada_no_servidor(user:String) -> void:
	rpc_id(1, "client_server_solicitar_entrada_no_servidor", id, user)

@rpc("any_peer", "reliable")
func client_server_notificar_saida_da_fila(user:String) -> void:
	rpc_id(1, "client_server_notificar_saida_da_fila", id, user)

@rpc("authority", "reliable")
func servidor_client_jogador_em_fila_de_espera() -> void:
	recebendo.jogador_em_fila_de_espera()

@rpc("authority", "reliable")
func servidor_client_jogador_saiu_da_fila_de_espera() -> void:
	recebendo.jogador_saiu_da_fila_de_espera()

@rpc("authority", "reliable")
func servidor_client_iniciar_partida() -> void:
	recebendo.iniciar_partida()

@rpc("any_peer", "reliable")
func client_server_verificar_se_jogadores_prontos() -> void:
	rpc_id(1, "client_server_verificar_se_jogadores_prontos", id)

@rpc("authority", "reliable")
func servidor_client_liberar_inicio_de_partida(sala:String) -> void:
	recebendo.liberar_inicio_de_partida(sala)

@rpc("any_peer", "reliable")
func client_server_coletar_racas_mais_banidas(sala:String) -> void:
	rpc_id(1, "client_server_coletar_racas_mais_banidas", id, sala)

@rpc("authority","reliable")
func servidor_client_racas_mais_banidas(racas_mais_banidas:Array) -> void:
	recebendo.racas_mais_banidas(racas_mais_banidas)

@rpc("any_peer", "reliable")
func client_server_informacoes_de_inicio_de_partida(dicionario:Dictionary, sala:String) -> void:
	rpc_id(1, "client_server_informacoes_de_inicio_de_partida", id, dicionario, sala)

@rpc("authority", "reliable")
func servidor_client_finalizar_inicio_de_partida(dicionario:Dictionary) -> void:
	recebendo.finalizar_inicio_de_partida(dicionario)

@rpc("any_peer", "reliable")
func client_server_solicitar_criar_pool(sala:String) -> void:
	rpc_id(1, "client_server_solicitar_criar_pool", sala, id)

@rpc("authority", "reliable")
func servidor_client_pool_criada(pool:Dictionary) -> void:
	recebendo.pool_criada(pool)

@rpc("any_peer", "reliable")
func client_server_solicitar_inicializacao_de_taverna(sala:String) -> void:
	rpc_id(1, "client_server_solicitar_inicializacao_de_taverna", sala, id)

@rpc("authority","reliable")
func servidor_client_informacoes_atualizadas(informacoes:Dictionary) -> void:
	recebendo.atualizacao_de_informacoes(informacoes)
