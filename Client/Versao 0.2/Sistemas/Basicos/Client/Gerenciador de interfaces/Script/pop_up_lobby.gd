class_name POP_UP_LOBBY
extends Control

signal fora_da_fila()
signal em_partida()

@onready var pictograma:TextureRect = $PlanoDeFundo/Centralizador/PlanoDeFundoMiolo/Marginalizador/OrganizadorMiolo/PlanoDeFundoPictograma/Marginalizador/Pictograma
@onready var barra_timer:TextureProgressBar = $PlanoDeFundo/Centralizador/PlanoDeFundoMiolo/Marginalizador/OrganizadorMiolo/PlanoDeFundoBarraTimer/Marginalizador/BarraTimer
@onready var etiqueta_timer:Label = $PlanoDeFundo/Centralizador/PlanoDeFundoMiolo/Marginalizador/OrganizadorMiolo/PlanoDeFundoBarraTimer/Marginalizador/BarraTimer/EtiquetaTimer
@onready var botao_cancelar:TextureButton = $PlanoDeFundo/Centralizador/PlanoDeFundoMiolo/Marginalizador/OrganizadorMiolo/Centralizador/BotaoCancelar
@onready var tempo_em_fila:Timer = $TempoEmFila

const tempo_maximo_em_fila_em_segundos:int = 100

var tempo_atual_em_fila_em_segundos:int = 0
var em_fila:bool = false :
	set = em_fila_modificado

func em_fila_modificado(value) -> void:
	if value == false:
		fora_da_fila.emit()
	em_fila = value

func inicializar() -> void:
	entrar_no_lobby()

func entrar_no_lobby() -> void:
	var user:String = get_tree().get_first_node_in_group("Client").name
	var id:int = multiplayer.get_unique_id()
	SERVER.enviando.solicitar_entrada_no_lobby(id,user)

func configurar_tempo_em_fila() -> void:
	tempo_em_fila.wait_time = tempo_maximo_em_fila_em_segundos
	tempo_em_fila.start()

func sair_do_lobby(sala_encontrada:bool) -> void:
	if sala_encontrada:
		em_fila = false
		tempo_em_fila.stop()
		barra_timer.tint_progress = "#00ff00"
		etiqueta_timer.set_text("Jogadores encontrados!")
		iniciar_partida()
		await em_partida
		fechar_pop_up()
	else:
		var user:String = get_tree().get_first_node_in_group("Client").name
		var id:int = multiplayer.get_unique_id()
		SERVER.enviando.notificar_saida_da_fila(id,user)
		await fora_da_fila
		fechar_pop_up()

func fechar_pop_up() -> void:
	get_tree().paused = false
	queue_free()

func _on_botao_cancelar_pressed():
	sair_do_lobby(false)

func _process(delta):
	tempo_atual_em_fila_em_segundos = tempo_maximo_em_fila_em_segundos - tempo_em_fila.time_left
	if em_fila:
		atualizar_status()

func atualizar_status() -> void:
	barra_timer.max_value = tempo_maximo_em_fila_em_segundos
	barra_timer.value = tempo_atual_em_fila_em_segundos
	
	var tempo_percentual:float = float(tempo_atual_em_fila_em_segundos) / float(tempo_maximo_em_fila_em_segundos) * 100
	
	if tempo_percentual < 30:
		barra_timer.tint_progress = "#00ff00"
		etiqueta_timer.set_text("Procurando jogadores")
	elif tempo_percentual < 60:
		barra_timer.tint_progress = "#ffff00"
		etiqueta_timer.set_text("Lutando para encontrar jogadores!")
	elif tempo_percentual < 98:
		barra_timer.tint_progress = "#ff0000"
		etiqueta_timer.set_text("Minha nossa senhora só tem você online?")
	else:
		barra_timer.tint_progress = "#ff0000"
		etiqueta_timer.set_text("Pelo visto a resposta é sim!")

func _on_tempo_em_fila_timeout():
	sair_do_lobby(false)

func iniciar_partida() -> void:
	print(get_tree().get_first_node_in_group("Client").name, " iniciou a partida!")
	await get_tree().create_timer(0.1).timeout
	em_partida.emit()
