class_name PAGINA_HOME_BASE
extends PAGINA_HOME_REFERENCIAS

var slide_counter:int = 0

func _ready():
	DATA.noticias_atualizadas.connect(atualizar_informacoes)

func quando_botao_voltar_carrossel_pressionado():
	slide_counter -= 1
	if slide_counter < 0:
		slide_counter = DATA.NoticiasInfo[Time.get_date_string_from_system()]["carrossel"].size() - 1
	
	carregar_novas_infos_do_carrossel()

func quando_botao_avancar_carrossel_pressionado():
	slide_counter += 1
	if slide_counter > DATA.NoticiasInfo[Time.get_date_string_from_system()]["carrossel"].size() - 1:
		slide_counter = 0
	
	carregar_novas_infos_do_carrossel()

func carregar_novas_infos_do_carrossel() -> void:
	imagem_carrossel.set_texture(load(DATA.NoticiasInfo[Time.get_date_string_from_system()]["carrossel"][str(slide_counter)]["img"]))
	texto_carrossel.set_text(DATA.NoticiasInfo[Time.get_date_string_from_system()]["carrossel"][str(slide_counter)]["texto"])

func quando_botao_jogar_pressionado():
	pass # Replace with function body.

func solicitar_noticias_de_jogo_ao_servidor() -> void:
	SERVER.enviando.solicitiar_update_de_noticias_ao_servidor()

func atualizar_informacoes() -> void:
	carregar_novas_infos_do_carrossel()
	texto_imagem_auxiliar_1.set_text(DATA.NoticiasInfo[Time.get_date_string_from_system()]["imagem_auxiliar_1"]["texto"])
	imagem_auxiliar_1.set_texture(load(DATA.NoticiasInfo[Time.get_date_string_from_system()]["imagem_auxiliar_1"]["img"]))
	texto_imagem_auxiliar_2.set_text(DATA.NoticiasInfo[Time.get_date_string_from_system()]["imagem_auxiliar_2"]["texto"])
	imagem_auxiliar_2.set_texture(load(DATA.NoticiasInfo[Time.get_date_string_from_system()]["imagem_auxiliar_2"]["img"]))
	texto_imagem_auxiliar_3.set_text(DATA.NoticiasInfo[Time.get_date_string_from_system()]["imagem_auxiliar_3"]["texto"])
	imagem_auxiliar_3.set_texture(load(DATA.NoticiasInfo[Time.get_date_string_from_system()]["imagem_auxiliar_3"]["img"]))

func atualizar_barra_de_xp(xp_atual:int, xp_maxima:int) -> void:
	barra_level.value = xp_atual
	barra_level.max_value = xp_maxima
