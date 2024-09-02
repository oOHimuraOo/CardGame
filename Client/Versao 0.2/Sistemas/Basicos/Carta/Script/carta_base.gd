class_name CARTA_BASE
extends CARTA_REFERENCIAS

signal hover_iniciado(carta:CARTA_BASE)
signal hover_terminado(carta:CARTA_BASE)
signal carta_clicada(carta:CARTA_BASE)

@export var carta_info: CARTA_INFO

var linha_atual:int = 0
var carta_no_deck:bool = false

var cor_de_tier:Dictionary = {
	"TIER_0": Color("#e7edea"),
	"TIER_1": Color("#ffc52c"),
	"TIER_2": Color("#fb0c06"),
	"TIER_3": Color("#030d4f")
}

var cor_de_raridade:Dictionary = {
	"MUITO_COMUM": Color("#dac8b3"),
	"COMUM": Color("#919a8b"),
	"INCOMUM": Color("#bab8b5"),
	"RARO": Color("#e7b555"),
	"MUITO_RARO": Color("#b00300")
}

var copia_grafica:CARTA_BASE
var em_hover:bool = false

func carregar_informacoes_da_carta(index:int, colecao:String) -> void:
	name = DATA.CardInfo[colecao][str(index)]["Nome"]
	
	criar_recurso()
	
	var textura_caminho = "res://Assets/Carta/Imagem/Cartas/" + DATA.CardInfo[colecao][str(index)]["Imagem"]
	carta_info.imagem = load(textura_caminho)
	
	carta_info.index = index
	carta_info.colecao = colecao
	
	carta_info.nome = DATA.CardInfo[colecao][str(index)]["Nome"]
	carta_info.tipo = DATA.CardInfo[colecao][str(index)]["Tipo"]
	carta_info.tier = cor_de_tier[DATA.CardInfo[colecao][str(index)]["Tier"]] 
	carta_info.custo = DATA.CardInfo[colecao][str(index)]["Valor"]
	carta_info.forca = DATA.CardInfo[colecao][str(index)]["Ataque"]
	carta_info.defesa = DATA.CardInfo[colecao][str(index)]["Defesa"]
	carta_info.raridade = cor_de_raridade[DATA.CardInfo[colecao][str(index)]["Raridade"]]
	
	if DATA.CardInfo[colecao][str(index)].has("Palavra-Chave"):
		carta_info.palavras_chave.append_array(DATA.CardInfo[colecao][str(index)]["Palavra-Chave"]) 
	
	if DATA.CardInfo[colecao][str(index)].has("Efeito"):
		carta_info.efeito = DATA.CardInfo[colecao][str(index)]["Efeito"]
	
	update_visual()
	ativar_palavras_chave()

func criar_recurso() -> void:
	carta_info = CARTA_INFO.new()

func quando_botao_detector_de_carta_pressionada():
	carta_clicada.emit(self)

func update_visual() -> void:
	etiqueta_custo.set_text(str(carta_info.custo))
	etiqueta_ataque.set_text(str(carta_info.forca))
	etiqueta_defesa.set_text(str(carta_info.defesa))
	etiqueta_nome.set_text(carta_info.nome)
	etiqueta_tipo.set_text(carta_info.tipo)
	cor_tier.color = carta_info.tier
	borda_plano_de_fundo.self_modulate = carta_info.raridade
	imagem_retrato_carta.set_texture(carta_info.imagem)
	texto_descritivo.clear()
	
	for palavra in carta_info.palavras_chave:
		if carta_info.palavras_chave.find(palavra) == 0:
			texto_descritivo.set_text(palavra + ", ")
		else:
			texto_descritivo.add_text(palavra + ", ")

func ativar_palavras_chave() -> void:
	if carta_info.palavras_chave.is_empty():
		return
	
	for palavra in carta_info.palavras_chave:
		instaciar_comportamento(palavra)

func instaciar_comportamento(nome_do_comportamento:String) -> void:
	var CIR: String = nome_do_comportamento.to_upper() + "_CENA"
	var comportamento_instancia = CONS.get(CIR).instantiate()
	maquina_de_comportamento.alocar_comportamento(comportamento_instancia)
	maquina_de_comportamento.verificar_maquina_de_comportamento()

func quando_botao_detector_de_carta_detectar_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 4:
			linha_atual -= 1
			if linha_atual < 0:
				linha_atual = 0
			
			texto_descritivo.scroll_to_line(linha_atual)
		elif event.button_index == 5:
			linha_atual += 1
			if linha_atual > texto_descritivo.get_line_count():
				linha_atual = texto_descritivo.get_line_count()
			
			texto_descritivo.scroll_to_line(linha_atual)



func _input(event):
	if !em_hover && event is InputEventMouseButton && event.button_index == 2 && event.pressed == true:
		if get_global_mouse_position().x > self.global_position.x && get_global_mouse_position().x < self.global_position.x + 200:
			if get_global_mouse_position().y > self.global_position.y && get_global_mouse_position().y < self.global_position.y + 284:
				em_hover = true
				hover_iniciado.emit(self)
				return
	
	if em_hover && event is InputEventMouseButton && (event.button_index == 2 || event.button_index == 1) && event.pressed == true:
		em_hover = false
		hover_terminado.emit(self)
		return

func aplicar_zoom_de_leitura(zoom:Vector2, posicao:Vector2, z:int) -> void:
	if !copia_grafica:
		#aplicar uma twen aqui
		copia_grafica = duplicate()
		get_parent().add_child(copia_grafica)
		copia_grafica.carregar_informacoes_da_carta(carta_info.index, carta_info.colecao)
		copia_grafica.botao_detector_de_carta.set_disabled(true)
		copia_grafica.scale = zoom
		copia_grafica.global_position = posicao
		copia_grafica.z_index = z
	else:
		copia_grafica.queue_free()
		copia_grafica = null
