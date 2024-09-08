class_name ENVIANDO
extends Node

func servidor_client_usuario_autenticado(autenticado:bool, verificador:bool, id:int, usuario:String = "", senha:String = "") -> void:
	if usuario != "" && senha != "":
		get_parent().servidor_client_usuario_autenticado(autenticado, verificador, id, usuario, senha)
		return
	get_parent().servidor_client_usuario_autenticado(autenticado, verificador, id)

func servidor_client_falha_ao_criar_cadastro(id:int) -> void:
	get_parent().servidor_client_falha_ao_criar_cadastro(id)

func servidor_client_sucesso_ao_criar_cadastro(id:int) -> void:
	get_parent().servidor_client_sucesso_ao_criar_cadastro(id)

func coletar_informacao_do_jogador(id:int, usuario:String) -> void:
	var usuario_real:String = get_parent().iniciando.aplicar_regra_hash_de_usuario(usuario)
	var account_info:Dictionary = DATA.UserData[usuario_real]["informcoes_do_jogador"]
	get_parent().servidor_client_enviar_informacao_do_jogador(id, account_info)

func coletar_informacoes_de_noticias(id:int) -> void:
	get_parent().servidor_client_enviar_noticias(id, DATA.NoticiasInfor)

func abrir_booster(boosters:Dictionary, usuario:String, id:int) -> void:
	randomize()
	var usuario_real:String = get_parent().iniciando.aplicar_regra_hash_de_usuario(usuario)
	var copia_de_boosters: Dictionary = boosters.duplicate()
	for edicao in copia_de_boosters:
		if DATA.UserData[usuario_real]["informcoes_do_jogador"]["packs"][edicao]["quantidade"] <= copia_de_boosters[edicao]["quantidade"]:
			copia_de_boosters[edicao]["quantidade"] = DATA.UserData[usuario_real]["informcoes_do_jogador"]["packs"][edicao]["quantidade"]
	
	var carta_tirada: Dictionary = {}
	for edicao in copia_de_boosters:
		carta_tirada[edicao] = {}
		for x in range(copia_de_boosters[edicao]["quantidade"]):
			for y in range(5):
				var index:int = randi_range(0,DATA.EdicaoTamanhos[edicao]["tamanho"])
				if carta_tirada[edicao].has(str(index)):
					carta_tirada[edicao][str(index)]["quantidade"] += 1
				else:
					carta_tirada[edicao][str(index)] = {"quantidade": 1}
	
	for edicao in copia_de_boosters:
		for x in range(copia_de_boosters[edicao]["quantidade"]):
			DATA.UserData[usuario_real]["informcoes_do_jogador"]["packs"][edicao]["quantidade"] -= 1
			print(edicao, "quantidade de booster disponivel:", DATA.UserData[usuario_real]["informcoes_do_jogador"]["packs"][edicao]["quantidade"])
	
	for edicao in carta_tirada:
		for carta in carta_tirada[edicao]:
			for x in range(carta_tirada[edicao][carta]["quantidade"]):
				if DATA.UserData[usuario_real]["informcoes_do_jogador"]["colecao"].has(edicao):
					DATA.UserData[usuario_real]["informcoes_do_jogador"]["colecao"][edicao] += [int(carta)]
				else:
					DATA.UserData[usuario_real]["informcoes_do_jogador"]["colecao"][edicao] = [int(carta)]
	
	DATA.salvar_user_info()
	get_parent().servidor_client_enviar_cartas_tiradas(carta_tirada, id)

func carregar_colecao(usuario:String, id:int) -> void:
	var usuario_real:String = get_parent().iniciando.aplicar_regra_hash_de_usuario(usuario)
	var colecao:Dictionary = DATA.UserData[usuario_real]["informcoes_do_jogador"]["colecao"]
	get_parent().servidor_client_enviar_colecao(colecao, id)

func carregar_deck(id:int, usuario:String, nome_do_deck:String) -> void:
	var usuario_real:String = get_parent().iniciando.aplicar_regra_hash_de_usuario(usuario)
	var deck: Dictionary = DATA.UserData[usuario_real]["informcoes_do_jogador"]["decks_do_jogador"][nome_do_deck]
	get_parent().servidor_client_enviar_deck(deck, id)

func finalizando_alteracao_de_deck(id:int, validacao:bool, msg:String) -> void:
	get_parent().servidor_client_enviar_resposta_de_validacao(id, validacao, msg)

func jogador_em_fila_de_espera(id:int) -> void:
	get_parent().servidor_client_jogador_em_fila_de_espera(id)

func jogador_saiu_da_fila(id:int) -> void:
	get_parent().servidor_client_jogador_saiu_da_fila_de_espera(id)

func iniciar_partida(lobby:Array) -> void:
	var array_de_ids:Array[int] = []
	for player in lobby:
		array_de_ids.append(int(CONLOB.jogadores_conectados[player].keys()[0])) 
	
	get_parent().servidor_client_iniciar_partida(array_de_ids)
