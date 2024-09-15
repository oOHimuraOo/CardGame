class_name OVERLAY_DE_INFORMACOES
extends OVERLAY_DE_INFORMACOES_REFERENCIAS

func atualizar_informacoes(informacoes_atuais:INFORMACAO_DE_JOGADOR) -> void:
	etiqueta_nick.set_text(informacoes_atuais.apelido + " como: ")
	etiqueta_nome_heroi.set_text(informacoes_atuais.heroi_nome)
	
	barra_vida.max_value = DATA.HeroiInfo[informacoes_atuais.heroi_nome]["Vida"]
	barra_vida.value = informacoes_atuais.vida
	etiqueta_vida.set_text(str(informacoes_atuais.vida))
	
	barra_escudo.max_value = DATA.HeroiInfo[informacoes_atuais.heroi_nome]["Escudo"]
	barra_escudo.value = informacoes_atuais.escudo
	etiqueta_escudo.set_text(str(informacoes_atuais.escudo))
	
	etiqueta_ataque.set_text(str(informacoes_atuais.ataque))

