class_name MINE_RETRATO_BASE
extends MINE_RETRATO_REFERENCIAS

signal revelar_informacoes(retrato:MINE_RETRATO_BASE, informacoes:INFORMACAO_DE_JOGADOR)
signal esconder_informacoes(retrato:MINE_RETRATO_BASE)

var informacoes_atuais:INFORMACAO_DE_JOGADOR

var vida_maxima:int
var vida_atual:int

var escudo_maximo:int
var escudo_atual:int

var posicao:int

func inicializar(informacoes:INFORMACAO_DE_JOGADOR) -> void:
	informacoes_atuais = informacoes
	carregar_texturas(informacoes.heroi_nome)
	carregar_vida(informacoes.vida)
	carregar_escudo(informacoes.escudo)
	carregar_ataque(informacoes.ataque)
	posicao = informacoes.posicao_atual + 1

func carregar_texturas(nome_do_heroi:String) -> void:
	var icon = load("res://icon.svg")
	retrato_heroi.set_texture(icon)

func carregar_vida(vida:int) -> void:
	vida_maxima = vida
	vida_atual = vida
	barra_de_vida.max_value = vida_maxima
	barra_de_vida.value = vida_atual
	if vida_atual <= 0:
		barra_de_vida.hide()
	else:
		barra_de_vida.show()

func carregar_escudo(escudo:int) -> void:
	escudo_maximo = escudo
	escudo_atual = escudo
	barra_de_escudo.max_value = escudo_maximo
	barra_de_escudo.value = escudo_atual
	if escudo_atual <= 0:
		barra_de_escudo.hide()
	else:
		barra_de_escudo.show()

func carregar_ataque(ataque:int) -> void:
	if ataque <= 0:
		icone_ataque.hide()
	else:
		icone_ataque.show()
		etiqueta_valor_ataque.set_text(str(ataque))

func quando_retrato_heroi_mouse_entrado():
	revelar_informacoes.emit(self, informacoes_atuais)

func quando_retrato_heroi_mouse_saido():
	esconder_informacoes.emit(self)
