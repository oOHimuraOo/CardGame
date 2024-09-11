extends Node

const quantidade_maxima_de_jogadores:int = 2

var jogadores_conectados: Dictionary = {}
var lobbys_criados: Dictionary = {}
var lobbys_em_partidas: Dictionary = {}
var numero_da_sala: int = 0

func adicionar_ou_atualizar_jogador_conectado(id:int, user_real:String, status:String) -> void:
	if jogadores_conectados.has(user_real):
		if jogadores_conectados[user_real].has(id):
			if jogadores_conectados[user_real][id]["status"] == status:
				return
			else:
				jogadores_conectados[user_real][id]["status"] = status
		else:
			jogadores_conectados[user_real].clear()
			jogadores_conectados[user_real][id] = {}
			jogadores_conectados[user_real][id]["status"] = status
	else:
		jogadores_conectados[user_real] = {}
		jogadores_conectados[user_real][id] = {}
		jogadores_conectados[user_real][id]["status"] = status

func criar_ou_gerenciar_lobby(id:int, user_real:String) -> void:
	if jogadores_conectados.has(user_real):
		if jogadores_conectados[user_real].has(id):
			if jogadores_conectados[user_real][id]["status"] == "em_espera" || jogadores_conectados[user_real][id]["status"] == "em_partida":
				return
		else:
			print("id do usuario nao reconhecido")
			return
	else:
		print("usuario não encontrado")
		return
	
	if lobbys_criados.is_empty():
		numero_da_sala = descobrir_sala_atual(numero_da_sala)
		var lobby_nome:String = "Sala_numero_" + str(numero_da_sala)
		lobbys_criados[lobby_nome] = []
		lobbys_criados[lobby_nome].append(user_real)
		adicionar_ou_atualizar_jogador_conectado(id, user_real, "em_espera")
		criar_timer(lobby_nome)
	else:
		for lobby in lobbys_criados:
			if lobbys_criados[lobby].size() >= quantidade_maxima_de_jogadores:
				numero_da_sala = descobrir_sala_atual(numero_da_sala)
				var lobby_nome:String = "Sala_numero_" + str(numero_da_sala)
				if !lobbys_criados.has(lobby_nome):
					lobbys_criados[lobby_nome] = []
					criar_timer(lobby_nome)
				lobbys_criados[lobby_nome].append(user_real)
				adicionar_ou_atualizar_jogador_conectado(id, user_real, "em_espera")
				break
			else:
				if !lobbys_criados[lobby].has(user_real):
					lobbys_criados[lobby].append(user_real)
					adicionar_ou_atualizar_jogador_conectado(id, user_real, "em_espera")
				break

func descobrir_sala_atual(numero_atual:int) -> int:
	var nome_da_sala:String = "Sala_numero_" + str(numero_atual)
	if lobbys_criados.has(nome_da_sala):
		if lobbys_criados[nome_da_sala].size() >= quantidade_maxima_de_jogadores:
			numero_atual += 1
			descobrir_sala_atual(numero_atual)
	
	return numero_atual

func criar_timer(lobby_nome:String) -> void:
	var timer_nome:String = "timer_da_" + lobby_nome
	if !find_child(timer_nome):
		var timer:Timer = Timer.new()
		timer.name = timer_nome
		timer.wait_time = 10
		add_child(timer)
		timer.start()
		timer.timeout.connect(atualizar_status_da_sala.bind(lobby_nome, timer))

func atualizar_status_da_sala(lobby_nome:String, timer:Timer) -> void:
	if lobbys_criados[lobby_nome].size() == quantidade_maxima_de_jogadores:
			var server = get_tree().get_first_node_in_group("Server")
			server.enviando.iniciar_partida(lobbys_criados[lobby_nome])
			for jogador in lobbys_criados[lobby_nome]:
				adicionar_ou_atualizar_jogador_conectado(jogadores_conectados[jogador].keys()[0], jogador, "em_partida")
			ajustar_padrao_lobby_em_partida(lobby_nome)
			lobbys_criados[lobby_nome].clear()
	
	elif lobbys_criados[lobby_nome].size() == 0:
		numero_da_sala = descobrir_numero_da_sala(lobby_nome)
		lobbys_criados.erase(lobby_nome)
		timer.timeout.disconnect(atualizar_status_da_sala)
		timer.stop()
		remove_child(timer)

func descobrir_numero_da_sala(lobby_nome:String) -> int:
	var numero:String
	for c in lobby_nome:
		if c.is_valid_int():
			numero += c
	return int(numero)

func sair_da_espera(id:int, usuario_real:String) -> void:
	jogadores_conectados[usuario_real][id]["status"] = "conectado"
	for sala in lobbys_criados:
		if lobbys_criados[sala].has(usuario_real):
			lobbys_criados[sala].erase(usuario_real)

func ajustar_padrao_lobby_em_partida(lobby_nome:String) -> void:
	if lobbys_em_partidas.has(lobby_nome):
		if lobbys_em_partidas[lobby_nome].size() > 0:
			var novo_nome:String = gerar_novo_nome_de_lobby()
			lobbys_em_partidas[novo_nome] = {}
			for user in lobbys_criados[lobby_nome]:
				var id:int = int(jogadores_conectados[user].keys()[0])
				formatar_dicionario_de_partida(novo_nome, id)
		else:
			for user in lobbys_criados[lobby_nome]:
				var id:int = int(jogadores_conectados[user].keys()[0])
				formatar_dicionario_de_partida(lobby_nome, id)
	else:
		lobbys_em_partidas[lobby_nome] = {}
		for user in lobbys_criados[lobby_nome]:
			var id:int = int(jogadores_conectados[user].keys()[0])
			formatar_dicionario_de_partida(lobby_nome, id)
	
	limpar_lobby_em_partidas()

func limpar_lobby_em_partidas() -> void:
	for sala in lobbys_em_partidas:
		if lobbys_em_partidas[sala].size() == 0:
			lobbys_em_partidas.erase(sala)

func formatar_dicionario_de_partida(nome:String, id:int) -> void:
	lobbys_em_partidas[nome][id] = {}
	lobbys_em_partidas[nome][id]["inicio_da_partida"] = false
	lobbys_em_partidas[nome][id]["manutencao"] = false
	lobbys_em_partidas[nome][id]["combate"] = false
	lobbys_em_partidas[nome][id]["sacrificio"] = false
	lobbys_em_partidas[nome][id]["especial"] = false

func gerar_novo_nome_de_lobby() -> String:
	randomize()
	var novo_numero:String = str(randi_range(1000,2500))
	var novo_nome:String = "Sala_numero_" + novo_numero
	if lobbys_em_partidas.has(novo_nome):
		gerar_novo_nome_de_lobby()
	return novo_nome
	
