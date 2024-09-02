class_name BORDA_DECK
extends NinePatchRect

signal deck_selecionado(nome_do_deck:String)

@onready var imagem_deck:TextureRect = $Marginalizador/OrganizadorMiolo/ImagemDeck
@onready var imagem_raca:TextureRect = $Marginalizador/OrganizadorMiolo/OrganizadorBarraInfo/ImagemRaca
@onready var etiqueta_nome_deck:Label = $Marginalizador/OrganizadorMiolo/OrganizadorBarraInfo/EtiquetaNomeDeck

var cartas_no_deck:Dictionary = {}

func _on_botao_selecionador_deck_pressed():
	deck_selecionado.emit(etiqueta_nome_deck.get_text())
