class_name INICIO_DA_PARTIDA_BASE
extends INICIO_DA_PARTIDA_REFERENCIAS

const tempo_em_segundos:int = 12

var racas_mais_banidas_pela_sala:Array = []
var lista_de_banidas:Array = []

var raca_selecionada_para_banir:TextureButton
var heroi_selecionado:NinePatchRect

var temporizador_de_raca:Timer
var temporizador_de_heroi:Timer
var tempo_maximo_de_heroi:int = 0
var tempo_faltando:int = 0

var botao_confirmar_desativado:bool = false

func _ready():
	get_tree().is_paused()
	coletar_racas_mais_banidas()
	conectar_botoes_selecao_de_raca()
	conectar_botoes_selecao_de_heroi()
	criar_temporizador_de_selecao_de_raca()

func conectar_botoes_selecao_de_heroi() -> void:
	selecionador_de_heroi_1.heroi_selecionado.connect(quando_heroi_selecionado)
	selecionador_de_heroi_2.heroi_selecionado.connect(quando_heroi_selecionado)
	selecionador_de_heroi_3.heroi_selecionado.connect(quando_heroi_selecionado)
	selecionador_de_heroi_4.heroi_selecionado.connect(quando_heroi_selecionado)

func quando_heroi_selecionado(selecionador:SELECIONADOR_DE_HEROI_BASE) -> void:
	if heroi_selecionado != selecionador:
		if heroi_selecionado:
			heroi_selecionado.modulate = "#ffffff"
		heroi_selecionado = selecionador
		heroi_selecionado.modulate = "#00ff00"
	else:
		heroi_selecionado.modulate = "#ffffff"
		heroi_selecionado = null

func coletar_racas_mais_banidas() -> void:
	var sala:String = get_parent().sala
	SERVER.enviando.coletar_racas_mais_banidas(sala)

func atualizar_visual_racas_banidas() -> void:
	for raca in racas_mais_banidas_pela_sala:
		match raca:
			"mortoVivo":
				botao_selecionar_morto_vivo.set_disabled(true)
			"besta":
				botao_selecionar_besta.set_disabled(true)
			"dragao":
				botao_selecionar_dragao.set_disabled(true)
			"naga":
				botao_selecionar_naga.set_disabled(true)
			"elemental":
				botao_selecionar_elemental.set_disabled(true)
			"pirata": 
				botao_selecionar_pirata.set_disabled(true)
			"elfo":
				botao_selecionar_elfo.set_disabled(true)
			"anao":
				botao_selecionar_anao.set_disabled(true)
			"metamorfo":
				botao_selecionar_metamorfo.set_disabled(true)
			"humano":
				botao_selecionar_humano.set_disabled(true)

func conectar_botoes_selecao_de_raca() -> void:
	var array_de_botoes:Array[String] = ["botao_selecionar_anao", "botao_selecionar_besta", "botao_selecionar_dragao", "botao_selecionar_elemental", "botao_selecionar_elfo", "botao_selecionar_humano",  "botao_selecionar_metamorfo", "botao_selecionar_morto_vivo","botao_selecionar_naga", "botao_selecionar_pirata"]
	for botao in array_de_botoes:
		get(botao).pressed.connect(quando_botao_selecionador_de_raca_pressionado.bind(get(botao)))
		

func quando_botao_selecionador_de_raca_pressionado(botao:TextureButton) -> void:
	if raca_selecionada_para_banir != botao:
		if raca_selecionada_para_banir:
			raca_selecionada_para_banir.button_pressed = false
		botao.button_pressed = true
		raca_selecionada_para_banir = botao
	else:
		raca_selecionada_para_banir.button_pressed = false
		raca_selecionada_para_banir = null

func _process(_delta):
	liberar_botao_confirmar()
	if temporizador_de_raca:
		atualizar_barra_de_tempo()
	elif temporizador_de_heroi:
		atualizar_barra_de_tempo_de_heroi()

func liberar_botao_confirmar() -> void:
	if botao_confirmar_desativado:
		botao_confirmar.set_disabled(true)
	else:
		if miolo_selecao_racas.is_visible_in_tree():
			if raca_selecionada_para_banir:
				botao_confirmar.set_disabled(false)
			else:
				botao_confirmar.set_disabled(true)
		elif miolo_selecao_herois.is_visible_in_tree():
			if heroi_selecionado:
				botao_confirmar.set_disabled(false)
			else:
				botao_confirmar.set_disabled(true)

func criar_temporizador_de_selecao_de_raca() -> void:
	temporizador_de_raca = Timer.new()
	temporizador_de_raca.name = "TemporizadorDeRaca"
	temporizador_de_raca.wait_time = tempo_em_segundos
	temporizador_de_raca.timeout.connect(quando_tempo_de_raca_acabar)
	temporizador_de_raca.one_shot = true
	add_child(temporizador_de_raca)
	temporizador_de_raca.start()
	atualizar_barra_de_tempo()

func quando_tempo_de_raca_acabar() -> void:
	if raca_selecionada_para_banir:
		miolo_selecao_racas.hide()
		miolo_selecao_herois.show()
		apagar_temporizador_raca()
		criar_temporizador_heroi(tempo_em_segundos)
	else:
		var array_de_botoes:Array[String] = ["botao_selecionar_anao", "botao_selecionar_besta", "botao_selecionar_dragao", "botao_selecionar_elemental", "botao_selecionar_elfo", "botao_selecionar_humano",  "botao_selecionar_metamorfo", "botao_selecionar_morto_vivo","botao_selecionar_naga", "botao_selecionar_pirata"]
		for botao in array_de_botoes:
			if get(botao).disabled == true:
				array_de_botoes.erase(botao)
		raca_selecionada_para_banir = get(array_de_botoes.pick_random())
		miolo_selecao_racas.hide()
		miolo_selecao_herois.show()
		apagar_temporizador_raca()
		criar_temporizador_heroi(tempo_em_segundos)

func atualizar_barra_de_tempo() -> void:
	tempo_faltando = int(float(tempo_em_segundos) - float(temporizador_de_raca.time_left))
	barra_de_tempo_selecao_racas.max_value = tempo_em_segundos
	barra_de_tempo_selecao_racas.value = tempo_faltando
	
	var valor_percentual:float = float(tempo_faltando) / float(tempo_em_segundos) * 100
	etiqueta_tempo_selecao_racas.set_text(str(tempo_faltando) + "/" + str(temporizador_de_raca.wait_time))
	
	if valor_percentual < 30:
		barra_de_tempo_selecao_racas.tint_progress = "#00ff00"
	elif valor_percentual < 60:
		barra_de_tempo_selecao_racas.tint_progress = "#ffff00"
	elif valor_percentual < 98:
		barra_de_tempo_selecao_racas.tint_progress = "#ff0000"
	else:
		barra_de_tempo_selecao_racas.tint_progress = "#ff00ff"

func quando_botao_confirmar_pressionado():
	if miolo_selecao_racas.is_visible_in_tree():
		temporizador_de_raca.paused = true
		var novo_tempo_maximo:int = int(temporizador_de_raca.time_left) + int(tempo_em_segundos)
		apagar_temporizador_raca()
		criar_temporizador_heroi(novo_tempo_maximo)
		miolo_selecao_racas.hide()
		miolo_selecao_herois.show()
	else:
		var dicionario:Dictionary = converter_informacoes_em_dicionario()
		SERVER.enviando.informacoes_de_inicio_de_partida(dicionario, get_parent().sala)
		etiqueta_confirmar.set_text("Esperando")
		botao_confirmar_desativado = true
		

func apagar_temporizador_raca() -> void:
	if temporizador_de_raca.timeout.is_connected(quando_tempo_de_raca_acabar):
		temporizador_de_raca.timeout.disconnect(quando_tempo_de_raca_acabar)
	temporizador_de_raca.queue_free()
	temporizador_de_raca = null

func criar_temporizador_heroi(tempo_maximo) -> void:
	tempo_maximo_de_heroi = tempo_maximo
	temporizador_de_heroi = Timer.new()
	temporizador_de_heroi.name = "TemporizadorDeHeroi"
	temporizador_de_heroi.wait_time = tempo_maximo
	temporizador_de_heroi.timeout.connect(quando_tempo_de_heroi_acabar)
	temporizador_de_heroi.one_shot = true
	add_child(temporizador_de_heroi)
	temporizador_de_heroi.start()
	atualizar_barra_de_tempo_de_heroi()

func quando_tempo_de_heroi_acabar() -> void:
	if heroi_selecionado:
		var dicionario:Dictionary = converter_informacoes_em_dicionario()
		SERVER.enviando.informacoes_de_inicio_de_partida(dicionario, get_parent().sala)
	else:
		var array_de_herois:Array[String] = ["selecionador_de_heroi_1", "selecionador_de_heroi_2", "selecionador_de_heroi_3", "selecionador_de_heroi_4"]
		heroi_selecionado = get(array_de_herois.pick_random())
		var dicionario:Dictionary = converter_informacoes_em_dicionario()
		SERVER.enviando.informacoes_de_inicio_de_partida(dicionario, get_parent().sala)

func atualizar_barra_de_tempo_de_heroi() -> void:
	tempo_faltando = int(float(tempo_maximo_de_heroi) - float(temporizador_de_heroi.time_left))
	barra_de_tempo_selecao_racas.max_value = tempo_maximo_de_heroi
	barra_de_tempo_selecao_racas.value = tempo_faltando
	
	var valor_percentual:float = float(tempo_faltando) / float(tempo_maximo_de_heroi) * 100
	etiqueta_tempo_selecao_racas.set_text(str(tempo_faltando) + "/" + str(temporizador_de_heroi.wait_time))
	
	if valor_percentual < 30:
		barra_de_tempo_selecao_racas.tint_progress = "#00ff00"
	elif valor_percentual < 60:
		barra_de_tempo_selecao_racas.tint_progress = "#ffff00"
	elif valor_percentual < 98:
		barra_de_tempo_selecao_racas.tint_progress = "#ff0000"
	else:
		barra_de_tempo_selecao_racas.tint_progress = "#ff00ff"

func converter_informacoes_em_dicionario() -> Dictionary:
	var dicionario:Dictionary = {
		multiplayer.get_unique_id(): [descobrir_raca(), descobrir_heroi()]
	}
	return dicionario

func descobrir_raca() -> String:
	var string_name:String
	match raca_selecionada_para_banir.name:
		"BotaoSelecionarAnao":
			string_name = "anao"
		"BotaoSelecionarBesta":
			string_name = "besta"
		"BotaoSelecionarDragao":
			string_name = "dragao"
		"BotaoSelecionarElemental":
			string_name = "elemental"
		"BotaoSelecionarElfo":
			string_name = "elfo"
		"BotaoSelecionarHumano":
			string_name = "humano"
		"BotaoSelecionarMetamorfo":
			string_name = "metamorfo"
		"BotaoSelecionarMortoVivo":
			string_name = "morto_vivo"
		"BotaoSelecionarNaga":
			string_name = "naga"
		"BotaoSelecionarPirata":
			string_name = "pirata"
	return string_name

func descobrir_heroi() -> String:
	return heroi_selecionado.informacoes.nome

func finalizar_inicio_de_partida() -> void:
	get_parent().inicializar_primeira_manutencao()
	self.queue_free()
