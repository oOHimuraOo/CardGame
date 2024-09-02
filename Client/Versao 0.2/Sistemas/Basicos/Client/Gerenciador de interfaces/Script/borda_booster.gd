class_name BORDA_BOOSTER
extends NinePatchRect

signal booster_selecionado(booster:BORDA_BOOSTER, edicao:String)

@onready var imagem_colecao_booster = $Marginalizador/ImagemColecaoBooster
@onready var etiqueta_colecao = $Marginalizador/ImagemColecaoBooster/EtiquetaColecao

var edicao:String = ""

func _ready():
	name = edicao + "_booster_1"
	etiqueta_colecao.set_text(name)

func quando_botao_destacar_booster_pressionado():
	booster_selecionado.emit(self, edicao)
