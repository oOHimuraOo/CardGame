class_name SELECIONADOR_DE_HEROI_BASE
extends SELECIONADOR_DE_HEROI_REFERENCIAS

signal heroi_selecionado(heroi:SELECIONADOR_DE_HEROI_BASE)

var informacoes:INFORMACAO_DE_HEROI

func iniciar_heroi(nome_do_heroi:String) -> void:
	informacoes = INFORMACAO_DE_HEROI.new()
	informacoes.nome = nome_do_heroi
	informacoes.forca = DATA.HeroiInfo[nome_do_heroi]["Forca"]
	informacoes.vida = DATA.HeroiInfo[nome_do_heroi]["Vida"]
	informacoes.escudo = DATA.HeroiInfo[nome_do_heroi]["Escudo"]
	informacoes.habilidade_de_heroi = DATA.HeroiInfo[nome_do_heroi]["Habilidade_de_heroi"]
	informacoes.poder_do_heroi = DATA.HeroiInfo[nome_do_heroi]["Poder_do_heroi"]
	
	registrar_informacoes()

func registrar_informacoes() -> void:
	etiqueta_nome.set_text(informacoes.nome)
	etiqueta_contador_de_vida.set_text(str(informacoes.vida))
	etiqueta_contador_de_ataque.set_text(str(informacoes.forca))
	etiqueta_contador_de_escudo.set_text(str(informacoes.escudo))
	texto_habilidade_1.set_text(informacoes.habilidade_de_heroi)
	texto_habilidade_2.set_text(informacoes.poder_do_heroi)
	
	implementar_texturas()

func implementar_texturas() -> void:
	print("texturas_implementadas!")

func quando_botao_selecionar_heroi_pressionado():
	heroi_selecionado.emit(self)
