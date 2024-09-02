class_name CARTA_LISTA
extends TextureButton

@onready var imagem_icone_raca = $OrganizadorCartaLista/ImagemIconeRaca
@onready var etiqueta_abreviacao_raca = $OrganizadorCartaLista/ImagemIconeRaca/EtiquetaAbreviacaoRaca
@onready var imagem_icone_custo = $OrganizadorCartaLista/ImagemIconeCusto
@onready var etiqueta_custo = $OrganizadorCartaLista/ImagemIconeCusto/EtiquetaCusto
@onready var nome_da_carta = $OrganizadorCartaLista/NomeDaCarta

var informacoes:Dictionary = {}
var idx:int

func distribuir_informacoes(info:Dictionary, index:int, edicao:String) -> void:
	informacoes = info
	idx = index
	etiqueta_custo.set_text(str(info["custo"]))
	nome_da_carta.set_text(info["nome"])
