class_name ENVIANDO
extends Node

func servidor_client_usuario_autenticado(autenticado:bool, verificador:bool, id:int, status:String, usuario:String = "", senha:String = "") -> void:
	if usuario != "" && senha != "":
		get_parent().servidor_client_usuario_autenticado(autenticado, verificador, id, status, usuario, senha)
		return
	get_parent().servidor_client_usuario_autenticado(autenticado, verificador, id, status)

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

func liberar_inicio_de_partida(id:int, sala:String) -> void:
	get_parent().servidor_client_liberar_inicio_de_partida(id, sala)

func coletar_racas_mais_banidas(id, sala) -> void:
	if CONLOB.lobbys_em_partidas[sala].has("racas_em_jogo"):
		get_parent().servidor_client_racas_mais_banidas(id, CONLOB.lobbys_em_partidas[sala]["racas_em_jogo"])
	else:
		var array_de_usuarios:Array[String] = []
		for jogador in CONLOB.lobbys_em_partidas[sala]:
			array_de_usuarios.append(descobrir_usuario_em_partida(jogador))
		
		var lista_de_banidas_da_sala:Array[String] = []
		for usuario in array_de_usuarios:
			var valor_a_1:int = -INF
			var valor_a_2:int = -INF
			var racas_mais_banidas_1:Array
			var racas_mais_banidas_2:Array
			
			var atalho:Dictionary = DATA.UserData[usuario]["informcoes_do_jogador"]["racas_banidas"]
			
			for raca in atalho:
				if atalho[raca] > valor_a_1 && !racas_mais_banidas_1.has(raca):
					valor_a_1 = int(atalho[raca])
					racas_mais_banidas_1.append(raca)
				elif atalho[raca] == valor_a_1 && !racas_mais_banidas_1.has(raca):
					racas_mais_banidas_1.append(raca)
			
			var dicionario_temporario:Dictionary = atalho.duplicate(true)
			for raca in racas_mais_banidas_1:
				dicionario_temporario.erase(raca)
			
			if !dicionario_temporario.is_empty():
				for raca in dicionario_temporario:
					if dicionario_temporario[raca] > valor_a_2 && !racas_mais_banidas_2.has(raca):
						valor_a_2 = int(dicionario_temporario[raca])
						racas_mais_banidas_2.append(raca)
					elif dicionario_temporario[raca] == valor_a_2 && !racas_mais_banidas_2.has(raca):
						racas_mais_banidas_2.append(raca)
			
			var raca_1:String
			var raca_2:String
			if racas_mais_banidas_1.size() == 1:
				raca_1 = racas_mais_banidas_1[0]
			elif racas_mais_banidas_1.size() > 1:
				raca_1 = racas_mais_banidas_1.pick_random()
				racas_mais_banidas_1.erase(raca_1)
				raca_2 = racas_mais_banidas_1.pick_random()
			
			if raca_2.is_empty():
				if racas_mais_banidas_2.size() == 1:
					raca_2 = racas_mais_banidas_2[0]
				elif racas_mais_banidas_2.size() > 1:
					raca_2 = racas_mais_banidas_2.pick_random()
			
			lista_de_banidas_da_sala.append(raca_1)
			lista_de_banidas_da_sala.append(raca_2)
		
		var valor_b_1:int = -INF
		var valor_b_2:int = -INF
		var raca_mais_banida_pela_sala_1:String
		var raca_mais_banida_pela_sala_2:String
		for raca in lista_de_banidas_da_sala:
			if lista_de_banidas_da_sala.count(raca) > valor_b_1 && raca_mais_banida_pela_sala_1 != raca:
				valor_b_1 = lista_de_banidas_da_sala.count(raca)
				raca_mais_banida_pela_sala_1 = raca
		
		for raca in lista_de_banidas_da_sala:
			if lista_de_banidas_da_sala.count(raca) > valor_b_2 && raca_mais_banida_pela_sala_1 != raca && raca_mais_banida_pela_sala_2 != raca:
				valor_b_2 = lista_de_banidas_da_sala.count(raca)
				raca_mais_banida_pela_sala_2 = raca
		
		var racas_mais_banidas:Array[String] = [raca_mais_banida_pela_sala_1, raca_mais_banida_pela_sala_2]
		CONLOB.lobbys_em_partidas[sala]["racas_em_jogo"] = []
		CONLOB.lobbys_em_partidas[sala]["racas_em_jogo"].append_array(racas_mais_banidas)
		get_parent().servidor_client_racas_mais_banidas(id, racas_mais_banidas)

func descobrir_usuario_em_partida(id:int) -> String:
	var user:String
	for usuario in CONLOB.jogadores_conectados:
		if int(CONLOB.jogadores_conectados[usuario].keys()[0]) == int(id):
			user = usuario
	return user

func descobrir_racas_mais_votadas_para_banimento(sala:String) -> void:
	var array_de_votos:Array = []
	for jogador in CONLOB.lobbys_em_partidas[sala]:
		if typeof(jogador) == 2:
			array_de_votos.append(CONLOB.lobbys_em_partidas[sala][jogador]["voto"])
	
	var valor_1:int = -INF
	var valor_2:int = -INF
	var raca_mais_votada:String
	var segunda_raca_mais_votada:String
	for voto in array_de_votos:
		if array_de_votos.count(voto) > valor_1 && raca_mais_votada != voto:
			valor_1 = array_de_votos.count(voto)
			raca_mais_votada = voto
		elif array_de_votos.count(voto) == valor_1 && raca_mais_votada != voto && segunda_raca_mais_votada != voto:
			segunda_raca_mais_votada = voto
		
	if segunda_raca_mais_votada.is_empty():
		for x in range(array_de_votos.size()):
			array_de_votos.erase(raca_mais_votada)
		
		for voto in array_de_votos:
			if array_de_votos.count(voto) > valor_2 && segunda_raca_mais_votada != voto:
				valor_2 = array_de_votos.count(voto)
				segunda_raca_mais_votada = voto
		
	CONLOB.lobbys_em_partidas[sala]["racas_banidas"] = [raca_mais_votada, segunda_raca_mais_votada]
	get_parent().servidor_client_finalizar_inicio_de_partida(sala)
