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
	montar_dicionario_de_primeira_manutencao(sala)
	#get_parent().servidor_client_finalizar_inicio_de_partida(sala)

func montar_dicionario_de_primeira_manutencao(sala:String) -> void:
	var dicionario:Dictionary = {}
	for jogador in CONLOB.lobbys_em_partidas[sala]:
		if typeof(jogador) == 2:
			if !dicionario.has(sala):
				dicionario[sala] = {}
			
			dicionario[sala]["rodada"] = 0
			
			if !dicionario[sala].has("jogadores"):
				dicionario[sala]["jogadores"] = {}
			
			if !dicionario[sala]["jogadores"].has(jogador):
				dicionario[sala]["jogadores"][jogador] = {}
			
			dicionario[sala]["jogadores"][jogador]["apelido"] = DATA.UserData[descobrir_usuario_em_partida(jogador)]["informcoes_do_jogador"]["nick"]
			
			if !dicionario[sala]["jogadores"][jogador].has("etapas_de_jogo"):
				dicionario[sala]["jogadores"][jogador]["etapas_de_jogo"] = {}
			
			dicionario[sala]["jogadores"][jogador]["etapas_de_jogo"]["inicio_de_partida"] = true
			dicionario[sala]["jogadores"][jogador]["etapas_de_jogo"]["manutencao"] = true
			dicionario[sala]["jogadores"][jogador]["etapas_de_jogo"]["combate"] = false
			dicionario[sala]["jogadores"][jogador]["etapas_de_jogo"]["sacrificio"] = false
			dicionario[sala]["jogadores"][jogador]["etapas_de_jogo"]["especial"] = false
			
			dicionario[sala]["jogadores"][jogador]["voto"] = CONLOB.lobbys_em_partidas[sala][jogador]["voto"]
			
			if !dicionario[sala]["jogadores"][jogador].has("has"):
				dicionario[sala]["jogadores"][jogador]["heroi"] = {}
			
			dicionario[sala]["jogadores"][jogador]["heroi"]["nome"] = CONLOB.lobbys_em_partidas[sala][jogador]["heroi"]
			dicionario[sala]["jogadores"][jogador]["heroi"]["vida"] = DATA.Hero_info[CONLOB.lobbys_em_partidas[sala][jogador]["heroi"]]["Vida"]
			dicionario[sala]["jogadores"][jogador]["heroi"]["ataque"] = DATA.Hero_info[CONLOB.lobbys_em_partidas[sala][jogador]["heroi"]]["Forca"]
			dicionario[sala]["jogadores"][jogador]["heroi"]["escudo"] = DATA.Hero_info[CONLOB.lobbys_em_partidas[sala][jogador]["heroi"]]["Escudo"]
			
			if !dicionario[sala]["jogadores"][jogador].has("resultado_de_partidas"):
				dicionario[sala]["jogadores"][jogador]["resultado_de_partidas"] = {}
			
			dicionario[sala]["jogadores"][jogador]["resultado_de_partidas"]["ultima_partida"] = "empate"
			dicionario[sala]["jogadores"][jogador]["resultado_de_partidas"]["penultima_partida"] = "empate"
			dicionario[sala]["jogadores"][jogador]["resultado_de_partidas"]["antepenultima_partida"] = "empate"
			
			dicionario[sala]["jogadores"][jogador]["posicao_atual"] = 0
			
			dicionario[sala]["jogadores"][jogador]["dinheiro_atual"] = calcular_dinheiro_atual(0)
			
			dicionario[sala]["racas_banidas"] = [CONLOB.lobbys_em_partidas[sala]["racas_banidas"]]
			
			dicionario[sala]["racas_em_jogo"] = descobrir_racas_em_jogo(sala)
	
	dicionario = calcular_posicao_atual(dicionario)
	CONLOB.infomacoes_de_partidas[sala] = dicionario[sala]
	get_parent().servidor_client_finalizar_inicio_de_partida(sala, dicionario)

func calcular_posicao_atual(dicionario:Dictionary) -> Dictionary:
	var novo_dicionario:Dictionary = dicionario.duplicate(true)
	var lista_de_posicoes:Array = ["primeiro", "segundo", "terceiro", "quarto", "quinto", "sexto", "setimo", "oitavo"]
	
	var dicionario_temp:Dictionary = {}
	for sala in dicionario:
		for jogador in dicionario[sala]["jogadores"]:
			var soma:int = dicionario[sala]["jogadores"][jogador]["heroi"]["vida"] + dicionario[sala]["jogadores"][jogador]["heroi"]["escudo"]
			dicionario_temp[jogador] = soma
	
	var index_ordenados:Array = organizar(dicionario_temp)
	
	var primeiro:int = index_ordenados[0]
	var segundo:int = index_ordenados[1]
	#var terceiro:int = index_ordenados[2]
	#var quarto:int = index_ordenados[3]
	#var quinto:int = index_ordenados[4]
	#var sexto:int = index_ordenados[5]
	#var setimo:int = index_ordenados[6]
	#var oitavo:int = index_ordenados[7]
	
	for sala in dicionario:
		for posicao in lista_de_posicoes:
			for jogador in dicionario[sala]["jogadores"]:
				if jogador == primeiro:
					novo_dicionario[sala]["jogadores"][jogador]["posicao_atual"] = 0
				elif jogador == segundo:
					novo_dicionario[sala]["jogadores"][jogador]["posicao_atual"] = 1
				#elif jogador == terceiro:
					#novo_dicionario[sala]["jogadores"][jogador]["posicao_atual"] = 2
				#elif jogador == quarto:
					#novo_dicionario[sala]["jogadores"][jogador]["posicao_atual"] = 3
				#elif jogador == quinto:
					#novo_dicionario[sala]["jogadores"][jogador]["posicao_atual"] = 4
				#elif jogador == sexto:
					#novo_dicionario[sala]["jogadores"][jogador]["posicao_atual"] = 5
				#elif jogador == setimo:
					#novo_dicionario[sala]["jogadores"][jogador]["posicao_atual"] = 6
				#elif jogador == oitavo:
					#novo_dicionario[sala]["jogadores"][jogador]["posicao_atual"] = 7
	
	return novo_dicionario

func calcular_dinheiro_atual(rodada_atual:int) -> int:
	if rodada_atual == 0:
		return int(3)
	else:
		return int(3 + rodada_atual)

func descobrir_racas_em_jogo(sala:String) -> Array:
	var primeira_raca = CONLOB.lobbys_em_partidas[sala]["racas_em_jogo"][0]
	var segunda_raca = CONLOB.lobbys_em_partidas[sala]["racas_em_jogo"][1]
	
	var array_de_racas:Array = ["anao", "besta", "dragao", "elemental", "elfo", "humano", "metamorfo", "mortoVivo", "naga", "pirata"]
	
	for raca in array_de_racas:
		if CONLOB.lobbys_em_partidas[sala]["racas_banidas"].has(raca):
			array_de_racas.erase(raca)
		if raca == primeira_raca:
			array_de_racas.erase(raca)
		if raca == segunda_raca:
			array_de_racas.erase(raca)
	
	var terceira_raca = array_de_racas.pick_random()
	array_de_racas.erase(terceira_raca)
	
	var quarta_raca = array_de_racas.pick_random()
	
	var racas_em_jogo:Array = [primeira_raca, segunda_raca, terceira_raca, quarta_raca]
	
	return racas_em_jogo

func organizar(dicionario: Dictionary) -> Array:
	var jogadores_e_somas:Array = []
	
	for jogador in dicionario:
		jogadores_e_somas.append([jogador, dicionario[jogador]])
	
	organizar_array(jogadores_e_somas, 0, jogadores_e_somas.size() -1)
	jogadores_e_somas.reverse()
	
	var array_de_index:Array = []
	for x in jogadores_e_somas:
		array_de_index.append(x[0])
	
	return array_de_index

func organizar_array(lista:Array, menor_valor:int, maior_valor:int) -> void:
	if lista.is_empty():
		return
	
	if menor_valor < maior_valor:
		var index_primario = particao_do_algoritimo(lista, menor_valor, maior_valor)
		
		organizar_array(lista, menor_valor, index_primario - 1)
		organizar_array(lista,index_primario + 1, maior_valor)

func particao_do_algoritimo(lista:Array, menor_valor:int, maior_valor:int) -> int:
	var pivot = lista[maior_valor]
	var i:int = menor_valor - 1
	
	for j in range(menor_valor, maior_valor):
		if lista[j][1] <= pivot[1]:
			i += 1
			var valor_temp = lista[i]
			lista[i] = lista[j]
			lista[j] = valor_temp
	
	lista[maior_valor] = lista[i+1]
	lista[i+1] = pivot
	
	return i+1

func criar_pool(sala:String, id:int) -> void:
	if CONLOB.infomacoes_de_partidas[sala].has("pool"):
		get_parent().servidor_client_pool_criada(CONLOB.infomacoes_de_partidas[sala]["pool"], id)
		return
	
	var pool:Dictionary = {}
	for jogador in CONLOB.infomacoes_de_partidas[sala]["jogadores"]:
		if CONLOB.infomacoes_de_partidas[sala]["jogadores"][jogador]["etapas_de_jogo"]["inicio_de_partida"]:
			CONLOB.infomacoes_de_partidas[sala]["jogadores"][jogador]["etapas_de_jogo"]["inicio_de_partida"] = false
			CONLOB.infomacoes_de_partidas[sala]["jogadores"][jogador]["decks_em_partida"] = {}
			for raca in CONLOB.infomacoes_de_partidas[sala]["racas_em_jogo"]:
				CONLOB.infomacoes_de_partidas[sala]["jogadores"][jogador]["decks_em_partida"][descobrir_nome_do_deck(raca)] = DATA.UserData[descobrir_usuario_em_partida(jogador)]["informcoes_do_jogador"]["decks_do_jogador"][descobrir_nome_do_deck(raca)]["cartas"]
	
	for jogador in CONLOB.infomacoes_de_partidas[sala]["jogadores"]:
		for deck in CONLOB.infomacoes_de_partidas[sala]["jogadores"][jogador]["decks_em_partida"]:
			for edicao in CONLOB.infomacoes_de_partidas[sala]["jogadores"][jogador]["decks_em_partida"][deck]:
				if !pool.has(edicao):
					pool[edicao] = []
				for carta in CONLOB.infomacoes_de_partidas[sala]["jogadores"][jogador]["decks_em_partida"][deck][edicao]:
					pool[edicao].append(carta)
	
	CONLOB.infomacoes_de_partidas[sala]["pool"] = {}
	CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_disponiveis"] = pool
	CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_em_descarte"] = {}
	CONLOB.infomacoes_de_partidas[sala]["pool"]["cartas_removidas"] = {}
	get_parent().servidor_client_pool_criada(CONLOB.infomacoes_de_partidas[sala]["pool"], id)

func descobrir_nome_do_deck(raca:String) -> String:
	var nome_do_deck:String
	match raca:
		"anao":
			nome_do_deck = "anao_base"
		"besta":
			nome_do_deck = "besta_base"
		"dragao":
			nome_do_deck = "dragao_base"
		"elemental":
			nome_do_deck = "elemental_base"
		"elfo":
			nome_do_deck = "elfo_base"
		"humano":
			nome_do_deck = "humano_base"
		"metamorfo":
			nome_do_deck = "metamorfo_base"
		"mortoVivo":
			nome_do_deck = "mortoVivo_base"
		"naga":
			nome_do_deck = "naga_base"
		"pirata":
			nome_do_deck = "pirata_base"
	return nome_do_deck

func informacoes_atualizadas(sala:String) -> void:
	var informacoes = CONLOB.infomacoes_de_partidas[sala]
	get_parent().servidor_client_informacoes_atualizadas(sala, informacoes)
