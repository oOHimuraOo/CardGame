class_name CARTA_INFO
extends Resource

@export var index:int
@export var colecao:String

@export var nome:String
@export var tipo:Array[String]
@export var imagem:Texture2D
@export var icone:Texture2D = preload("res://icon.svg")

@export var raridade:Color

@export var custo:int
@export var tier:Color

@export var forca:int
@export var defesa:int

@export var palavras_chave:Array[String]
@export var efeito:String
