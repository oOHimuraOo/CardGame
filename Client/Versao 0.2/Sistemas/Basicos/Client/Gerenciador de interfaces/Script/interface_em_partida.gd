class_name INTERFACE_EM_PARTIDA
extends INTERFACE_EM_PARTIDA_REFERENCIAS

signal jogadores_prontos()
signal listas_de_cartas_atualizadas()

const posicao_zerada:Vector2 = Vector2.ZERO
const escala_padrao:Vector2 = Vector2(1,1)
const posicao_centralizada_com_offset:Vector2 = Vector2(710,185)
const escala_taverna:Vector2 = Vector2(0.5,0.5)
const escala_mao:Vector2 = Vector2(0.5,0.5)
const escala_campo:Vector2 = Vector2(0.5,0.5)

var sala:String

var rodada_atual = 0

var informacao_de_heroi:INFORMACAO_DE_HEROI

var informacao_jogador_1:INFORMACAO_DE_JOGADOR
var informacao_jogador_2:INFORMACAO_DE_JOGADOR
var informacao_jogador_3:INFORMACAO_DE_JOGADOR
var informacao_jogador_4:INFORMACAO_DE_JOGADOR
var informacao_jogador_5:INFORMACAO_DE_JOGADOR
var informacao_jogador_6:INFORMACAO_DE_JOGADOR
var informacao_jogador_7:INFORMACAO_DE_JOGADOR
var informacao_jogador_8:INFORMACAO_DE_JOGADOR

var posicao_antiga_de_carta:Vector2

var dinheiro_atual:int
var dinheiro_maximo_atual:int

var tempo_de_rodada:int = 45
var lista_racas_em_partida:Array = []

var informacao_criada:bool = false

var tamanho_pool:int
var cartas_disponiveis:Dictionary = {}

var tamanho_descarte:int 
var cartas_no_descarte:Dictionary = {}

var tamanho_removidas:int
var cartas_removidas:Dictionary = {}

var tamanho_cartas_na_taverna:int
var cartas_na_taverna:Dictionary = {}

var tamanho_cartas_na_mao:int
var cartas_na_mao:Dictionary = {}

var tamanho_cartas_no_campo:int
var cartas_no_campo:Dictionary = {}

func esperar_jogadores_prontos() -> void:
	SERVER.enviando.verificar_se_jogadores_prontos()
	await jogadores_prontos
	iniciar_partida()

func iniciar_partida() -> void:
	var inicio_de_partida_instancia = CONS.INICIO_DE_PARTIDA_CENA.instantiate()
	add_child(inicio_de_partida_instancia)
	var array_de_herois:Array = gerar_lista_de_herois()
	inicio_de_partida_instancia.selecionador_de_heroi_1.iniciar_heroi(array_de_herois[0])
	inicio_de_partida_instancia.selecionador_de_heroi_2.iniciar_heroi(array_de_herois[1])
	inicio_de_partida_instancia.selecionador_de_heroi_3.iniciar_heroi(array_de_herois[2])
	inicio_de_partida_instancia.selecionador_de_heroi_4.iniciar_heroi(array_de_herois[3])

func gerar_lista_de_herois() -> Array:
	randomize()
	var array:Array = []
	var nomes:Array = DATA.HeroiInfo.keys()
	for x in range(4):
		var nome = nomes.pick_random()
		array.append(nome)
		nomes.erase(nome)
	
	return array

func inicializar_primeira_manutencao(dicionario:Dictionary) -> void:
	listas_de_cartas_atualizadas.connect(atualizar_informacoes_de_pool)
	atualizar_informacoes_gerais(dicionario)
	atualizar_posicoes()
	carregar_info_de_partida(dicionario)
	ajustar_barra_timer()
	inicializar_taverna()
	inicializar_jogador(dicionario)

func atualizar_informacoes_de_pool() -> void:
	etiqueta_pool_atual.set_text(str(tamanho_pool))
	etiqueta_descarte_atual.set_text(str(tamanho_descarte))

func atualizar_informacoes_gerais(dicionario:Dictionary) -> void:
	rodada_atual = dicionario[sala]["rodada"]
	var array_de_jogadores = ["informacao_jogador_1", "informacao_jogador_2", "informacao_jogador_3", "informacao_jogador_4", "informacao_jogador_5", "informacao_jogador_6", "informacao_jogador_7", "informacao_jogador_8"]
	for jogador in dicionario[sala]["jogadores"]:
		for nome in array_de_jogadores:
			if !get(nome):
				set(nome, INFORMACAO_DE_JOGADOR.new())
				get(nome).apelido = dicionario[sala]["jogadores"][jogador]["apelido"]
				get(nome).heroi_nome = dicionario[sala]["jogadores"][jogador]["heroi"]["nome"]
				get(nome).vida = dicionario[sala]["jogadores"][jogador]["heroi"]["vida"]
				get(nome).escudo = dicionario[sala]["jogadores"][jogador]["heroi"]["escudo"]
				get(nome).ataque = dicionario[sala]["jogadores"][jogador]["heroi"]["ataque"]
				get(nome).posicao_atual = dicionario[sala]["jogadores"][jogador]["posicao_atual"]
				informacao_jogador_1.ultima_partida = dicionario[sala]["jogadores"][jogador]["resultado_de_partidas"]["ultima_partida"]
				informacao_jogador_1.penultima_partida = dicionario[sala]["jogadores"][jogador]["resultado_de_partidas"]["penultima_partida"]
				informacao_jogador_1.antepenultima_partida = dicionario[sala]["jogadores"][jogador]["resultado_de_partidas"]["antepenultima_partida"]
				break
	
	mine_retrato_borda_1.inicializar(informacao_jogador_1)
	mine_retrato_borda_2.inicializar(informacao_jogador_2)
	#mine_retrato_borda_3.inicializar(informacao_jogador_3)
	#mine_retrato_borda_4.inicializar(informacao_jogador_4)
	#mine_retrato_borda_5.inicializar(informacao_jogador_5)
	#mine_retrato_borda_6.inicializar(informacao_jogador_6)
	#mine_retrato_borda_7.inicializar(informacao_jogador_7)
	#mine_retrato_borda_8.inicializar(informacao_jogador_8)
	
	dinheiro_atual = dicionario[sala]["jogadores"][multiplayer.get_unique_id()]["dinheiro_atual"]
	dinheiro_maximo_atual = 3 + rodada_atual
	
	lista_racas_em_partida.append_array(dicionario[sala]["racas_em_jogo"]) 
	
	if dicionario[sala]["jogadores"][multiplayer.get_unique_id()].has("taverna"):
		cartas_na_taverna = dicionario[sala]["jogadores"][multiplayer.get_unique_id()]["taverna"]["cartas_exibidas"]
		distribuir_cartas_na_taverna()
		atualizar_pool(dicionario[sala]["pool"])
	
	if dicionario[sala]["jogadores"][multiplayer.get_unique_id()].has("mao"):
		print("tenho_mao")
	
	if dicionario[sala]["jogadores"][multiplayer.get_unique_id()].has("campo"):
		print("tenho_campo")

func atualizar_posicoes() -> void:
	var lista_de_nomes:Array = ["mine_retrato_borda_1", "mine_retrato_borda_2"]#, "mine_retrato_borda_3", "mine_retrato_borda_4", "mine_retrato_borda_5", "mine_retrato_borda_6", "mine_retrato_borda_7", "mine_retrato_borda_8"]
	for nome in lista_de_nomes:
		organizador_borda_esquerda.move_child(get(nome), get(nome).posicao)
		conectar_sinais(get(nome))

func conectar_sinais(retrato:MINE_RETRATO_BASE) -> void:
	retrato.revelar_informacoes.connect(quando_revelar_informacoes)
	retrato.esconder_informacoes.connect(quando_esconder_informacoes)

func quando_revelar_informacoes(retrato:MINE_RETRATO_BASE, informacoes_atuais:INFORMACAO_DE_JOGADOR) -> void:
	var lista_de_nomes:Array = ["mine_retrato_borda_1", "mine_retrato_borda_2"]#, "mine_retrato_borda_3", "mine_retrato_borda_4", "mine_retrato_borda_5", "mine_retrato_borda_6", "mine_retrato_borda_7", "mine_retrato_borda_8"]
	for nome in lista_de_nomes:
		if get(nome) == retrato:
			var informacoes_cena:PackedScene = load("res://Sistemas/Basicos/Client/Gerenciador de interfaces/Sub Cenas/overlay_de_informacoes_de_partida.tscn")
			var informacoes_instancia = informacoes_cena.instantiate()
			add_child(informacoes_instancia)
			informacoes_instancia.global_position += Vector2(50,150)
			informacoes_instancia.atualizar_informacoes(informacoes_atuais)
			informacao_criada = true

func quando_esconder_informacoes(retrato:MINE_RETRATO_BASE) -> void:
	var lista_de_nomes:Array = ["mine_retrato_borda_1", "mine_retrato_borda_2"]#, "mine_retrato_borda_3", "mine_retrato_borda_4", "mine_retrato_borda_5", "mine_retrato_borda_6", "mine_retrato_borda_7", "mine_retrato_borda_8"]
	for nome in lista_de_nomes:
		if get(nome) == retrato:
			get_tree().get_first_node_in_group("Overlay").queue_free()
			informacao_criada = false

func carregar_info_de_partida(dicionario:Dictionary) -> void:
	montar_pool()
	racas_em_partida(dicionario)

func montar_pool() -> void:
	SERVER.enviando.solicitar_criar_pool(sala)

func racas_em_partida(dicionario:Dictionary) -> void:
	var slot_1:bool = false
	var slot_2:bool = false
	var slot_3:bool = false
	var slot_4:bool = false
	
	for raca in dicionario[sala]["racas_em_jogo"]:
		if !slot_1:
			slot_1 = true
			match raca:
				"anao":
					retrato_icone_raca_1.set_texture(load("res://Assets/Carta/Imagem/Cartas/Anao_Placeholder.jpg"))
				"besta":
					retrato_icone_raca_1.set_texture(load("res://Assets/Carta/Imagem/Cartas/Besta_Placeholder.jpg"))
				"dragao":
					retrato_icone_raca_1.set_texture(load("res://Assets/Carta/Imagem/Cartas/Dragao_Placeholder.jpg"))
				"elemental":
					retrato_icone_raca_1.set_texture(load("res://Assets/Carta/Imagem/Cartas/Elemental_Placeholder.jpg"))
				"elfo":
					retrato_icone_raca_1.set_texture(load("res://Assets/Carta/Imagem/Cartas/Elfo_Placeholder.jpg"))
				"humano":
					retrato_icone_raca_1.set_texture(load("res://Assets/Carta/Imagem/Cartas/Humano_Placeholder.jpg"))
				"metamorfo":
					retrato_icone_raca_1.set_texture(load("res://Assets/Carta/Imagem/Cartas/Metamorfo_Placeholder.jpg"))
				"mortoVivo":
					retrato_icone_raca_1.set_texture(load("res://Assets/Carta/Imagem/Cartas/MortoVivo_Placeholder.jpg"))
				"naga":
					retrato_icone_raca_1.set_texture(load("res://Assets/Carta/Imagem/Cartas/Naga_Placeholder.jpg"))
				"pirata":
					retrato_icone_raca_1.set_texture(load("res://Assets/Carta/Imagem/Cartas/Pirata_Placeholder.jpg"))
		elif slot_1 && !slot_2:
			slot_2 = true
			match raca:
				"anao":
					retrato_icone_raca_2.set_texture(load("res://Assets/Carta/Imagem/Cartas/Anao_Placeholder.jpg"))
				"besta":
					retrato_icone_raca_2.set_texture(load("res://Assets/Carta/Imagem/Cartas/Besta_Placeholder.jpg"))
				"dragao":
					retrato_icone_raca_2.set_texture(load("res://Assets/Carta/Imagem/Cartas/Dragao_Placeholder.jpg"))
				"elemental":
					retrato_icone_raca_2.set_texture(load("res://Assets/Carta/Imagem/Cartas/Elemental_Placeholder.jpg"))
				"elfo":
					retrato_icone_raca_2.set_texture(load("res://Assets/Carta/Imagem/Cartas/Elfo_Placeholder.jpg"))
				"humano":
					retrato_icone_raca_2.set_texture(load("res://Assets/Carta/Imagem/Cartas/Humano_Placeholder.jpg"))
				"metamorfo":
					retrato_icone_raca_2.set_texture(load("res://Assets/Carta/Imagem/Cartas/Metamorfo_Placeholder.jpg"))
				"mortoVivo":
					retrato_icone_raca_2.set_texture(load("res://Assets/Carta/Imagem/Cartas/MortoVivo_Placeholder.jpg"))
				"naga":
					retrato_icone_raca_2.set_texture(load("res://Assets/Carta/Imagem/Cartas/Naga_Placeholder.jpg"))
				"pirata":
					retrato_icone_raca_2.set_texture(load("res://Assets/Carta/Imagem/Cartas/Pirata_Placeholder.jpg"))
		elif slot_1 && slot_2 && !slot_3:
			slot_3 = true
			match raca:
				"anao":
					retrato_icone_raca_3.set_texture(load("res://Assets/Carta/Imagem/Cartas/Anao_Placeholder.jpg"))
				"besta":
					retrato_icone_raca_3.set_texture(load("res://Assets/Carta/Imagem/Cartas/Besta_Placeholder.jpg"))
				"dragao":
					retrato_icone_raca_3.set_texture(load("res://Assets/Carta/Imagem/Cartas/Dragao_Placeholder.jpg"))
				"elemental":
					retrato_icone_raca_3.set_texture(load("res://Assets/Carta/Imagem/Cartas/Elemental_Placeholder.jpg"))
				"elfo":
					retrato_icone_raca_3.set_texture(load("res://Assets/Carta/Imagem/Cartas/Elfo_Placeholder.jpg"))
				"humano":
					retrato_icone_raca_3.set_texture(load("res://Assets/Carta/Imagem/Cartas/Humano_Placeholder.jpg"))
				"metamorfo":
					retrato_icone_raca_3.set_texture(load("res://Assets/Carta/Imagem/Cartas/Metamorfo_Placeholder.jpg"))
				"mortoVivo":
					retrato_icone_raca_3.set_texture(load("res://Assets/Carta/Imagem/Cartas/MortoVivo_Placeholder.jpg"))
				"naga":
					retrato_icone_raca_3.set_texture(load("res://Assets/Carta/Imagem/Cartas/Naga_Placeholder.jpg"))
				"pirata":
					retrato_icone_raca_3.set_texture(load("res://Assets/Carta/Imagem/Cartas/Pirata_Placeholder.jpg"))
		elif slot_1 && slot_2 && slot_3 && !slot_4:
			slot_4 = true
			match raca:
				"anao":
					retrato_icone_raca_4.set_texture(load("res://Assets/Carta/Imagem/Cartas/Anao_Placeholder.jpg"))
				"besta":
					retrato_icone_raca_4.set_texture(load("res://Assets/Carta/Imagem/Cartas/Besta_Placeholder.jpg"))
				"dragao":
					retrato_icone_raca_4.set_texture(load("res://Assets/Carta/Imagem/Cartas/Dragao_Placeholder.jpg"))
				"elemental":
					retrato_icone_raca_4.set_texture(load("res://Assets/Carta/Imagem/Cartas/Elemental_Placeholder.jpg"))
				"elfo":
					retrato_icone_raca_4.set_texture(load("res://Assets/Carta/Imagem/Cartas/Elfo_Placeholder.jpg"))
				"humano":
					retrato_icone_raca_4.set_texture(load("res://Assets/Carta/Imagem/Cartas/Humano_Placeholder.jpg"))
				"metamorfo":
					retrato_icone_raca_4.set_texture(load("res://Assets/Carta/Imagem/Cartas/Metamorfo_Placeholder.jpg"))
				"mortoVivo":
					retrato_icone_raca_4.set_texture(load("res://Assets/Carta/Imagem/Cartas/MortoVivo_Placeholder.jpg"))
				"naga":
					retrato_icone_raca_4.set_texture(load("res://Assets/Carta/Imagem/Cartas/Naga_Placeholder.jpg"))
				"pirata":
					retrato_icone_raca_4.set_texture(load("res://Assets/Carta/Imagem/Cartas/Pirata_Placeholder.jpg"))

func ajustar_barra_timer() -> void:
	atualizar_dinheiro()
	incializar_timer()

func _process(_delta):
	reajustar_transforme_de_etiqueta()
	atualizar_barra_de_tempo()

func atualizar_dinheiro() -> void:
	etiqueta_ouro.set_text(str(dinheiro_atual) + "/" + str(dinheiro_maximo_atual))
	var array_de_dinheiro:Array = ["ouro_slot_1", "ouro_slot_2", "ouro_slot_3", "ouro_slot_4", "ouro_slot_5", "ouro_slot_6", "ouro_slot_7", "ouro_slot_8", "ouro_slot_9", "ouro_slot_10"]
	for x in range(dinheiro_maximo_atual):
		get(array_de_dinheiro[x]).show()
	
	array_de_dinheiro.reverse()
	for dinheiro in array_de_dinheiro:
		revelar_dinheiro_gasto(get(dinheiro))

func revelar_dinheiro_gasto(dinheiro:TextureRect) -> void:
	if dinheiro.is_visible_in_tree():
		if dinheiro.get_index() > dinheiro_atual && dinheiro.get_index() <= dinheiro_maximo_atual:
			dinheiro.modulate = "#ff0000"
		else:
			dinheiro.modulate = "#ffffff"

func reajustar_transforme_de_etiqueta() -> void:
	etiqueta_tempo_disponivel.size.x = barra_tempo_disponivel.size.y
	etiqueta_tempo_disponivel.size.y = barra_tempo_disponivel.size.x
	etiqueta_tempo_disponivel.position.y = barra_tempo_disponivel.size.y

func incializar_timer() -> void:
	temporizador_de_turno.wait_time = tempo_de_rodada
	temporizador_de_turno.start()

func atualizar_barra_de_tempo() -> void:
	var tempo_atual:int = int(float(tempo_de_rodada) - float(temporizador_de_turno.time_left))
	barra_tempo_disponivel.max_value = tempo_de_rodada
	barra_tempo_disponivel.value = tempo_atual
	
	var tempo_percentual:float = tempo_atual / tempo_de_rodada * 100
	etiqueta_tempo_disponivel.set_text(str(int(temporizador_de_turno.time_left)) + "/" + str(tempo_de_rodada))
	
	if tempo_percentual < 33:
		barra_tempo_disponivel.tint_progress = "#00ff00"
	elif tempo_percentual < 66:
		barra_tempo_disponivel.tint_progress = "#ffff00"
	elif tempo_percentual < 99:
		barra_tempo_disponivel.tint_progress = "#ff0000"

func inicializar_taverna() -> void:
	SERVER.enviando.solicitar_inicializacao_de_taverna(sala)

func distribuir_cartas_na_taverna() -> void:
	var lista_de_slots_de_taverna:Array[String] = ["taberna_slot_1", "taberna_slot_2", "taberna_slot_3", "taberna_slot_4"]
	for edicao in cartas_na_taverna:
		for slot in lista_de_slots_de_taverna:
			for carta in cartas_na_taverna[edicao]:
				var carta_instancia:CARTA_BASE = CONS.CARTA_CENA.instantiate()
				carta_instancia.scale = escala_taverna
				carta_instancia.position = posicao_zerada
				get(slot).add_child(carta_instancia)
				carta_instancia.carregar_informacoes_da_carta(carta,edicao)
				carta_instancia.hover_iniciado.connect(aplicar_zoom)
				carta_instancia.hover_terminado.connect(retirar_zoom)
				carta_instancia.carta_clicada.connect(mover_carta)
				break

func inicializar_jogador(dicionario:Dictionary) -> void:
	var heroi_nome:String = dicionario[sala]["jogadores"][multiplayer.get_unique_id()]["heroi"]["nome"]
	informacao_de_heroi = INFORMACAO_DE_HEROI.new()
	informacao_de_heroi.nome = heroi_nome
	informacao_de_heroi.forca = DATA.HeroiInfo[heroi_nome]["Forca"]
	informacao_de_heroi.vida = DATA.HeroiInfo[heroi_nome]["Vida"]
	informacao_de_heroi.escudo = DATA.HeroiInfo[heroi_nome]["Escudo"]
	informacao_de_heroi.habilidade_de_heroi = DATA.HeroiInfo[heroi_nome]["Habilidade_de_heroi"]
	informacao_de_heroi.poder_do_heroi = DATA.HeroiInfo[heroi_nome]["Poder_do_heroi"]
	informacao_de_heroi.cadastrar_habilidade_e_poder_de_heroi_no_gerenciador_de_regras_de_jogo()
	retrato_heroi.set_texture(load("res://icon.svg"))

func atualizar_pool(pool:Dictionary) -> void:
	for local in pool:
		if local == "cartas_disponiveis":
			tamanho_pool = 0
			for edicao in pool["cartas_disponiveis"]:
				tamanho_pool += pool["cartas_disponiveis"][edicao].size()
		if local == "cartas_em_descarte":
			tamanho_descarte = 0
			for edicao in pool["cartas_em_descarte"]:
				tamanho_descarte += pool["cartas_em_descarte"][edicao].size()
		if local == "cartas_removidas":
			tamanho_removidas = 0
			for edicao in pool["cartas_removidas"]:
				tamanho_removidas += pool["cartas_removidas"][edicao].size()
	
	listas_de_cartas_atualizadas.emit()

func aplicar_zoom(carta:CARTA_BASE) -> void:
	posicao_antiga_de_carta = carta.global_position
	carta.aplicar_zoom_de_leitura(escala_padrao, posicao_centralizada_com_offset, 100)

func retirar_zoom(carta:CARTA_BASE) -> void:
	match carta.get_parent().get_parent().name:
		"OrganizadorCartasTaberna":
			carta.aplicar_zoom_de_leitura(escala_taverna, posicao_antiga_de_carta, 0)
		"OrganizadorCartasCampoDeBatalha":
			carta.aplicar_zoom_de_leitura(escala_campo, posicao_antiga_de_carta, 0)
		"OrganizadorMao":
			carta.aplicar_zoom_de_leitura(escala_mao, posicao_antiga_de_carta, 0)

func quando_botao_poder_heroi_pressionado():
	informacao_de_heroi.ativar_efeito_do_poder_no_gerenciador_de_regras_de_jogo()

func quando_botao_melhorar_pressionado():
	print("melhorei a taverna")

func quando_botao_congelar_pressionado():
	print("congelei a taverna")

func quando_botao_atualizar_pressionado():
	print("atualizei a taverna")

func quando_botao_terminar_turno_pressionado():
	print("terminei meu turno")

func mover_carta(carta:CARTA_BASE) -> void:
	print("movi a carta")
