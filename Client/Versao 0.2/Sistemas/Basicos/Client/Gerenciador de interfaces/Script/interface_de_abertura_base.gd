class_name INTERFACE_DE_ABERTURA_BASE
extends INTERFACE_DE_ABERTURA_REFERENCIAS


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	realizar_conecoes_de_sinais_iniciais()

func realizar_conecoes_de_sinais_iniciais() -> void:
	botao_cancelar.pressed.connect(quando_botao_cancelar_pressionado)
	botao_confirmar.pressed.connect(quando_botao_confirmar_pressionado)
	botao_creditos.pressed.connect(quando_botao_creditos_pressionado)
	botao_criar.pressed.connect(quando_botao_criar_pressionado)
	botao_criar_conta.pressed.connect(quando_botao_criar_conta_pressionado)
	#botao_opcoes.pressed.connect(quando_botao_opcoes_pressionado)
	botao_patch_notes.pressed.connect(quando_botao_patch_notes_pressionado)
	botao_sair.pressed.connect(quando_botao_sair_pressionado)
	botao_voltar_creditos.pressed.connect(quando_botao_voltar_creditos_pressionado)
	botao_voltar_patch_notes.pressed.connect(quando_botao_voltar_patch_notes_pressionado)

func pop_up_de_sucesso() -> void:
	var cena:PackedScene = load("res://Sistemas/Basicos/Client/Gerenciador de interfaces/Sub Cenas/pop_up.tscn")
	var instancia = cena.instantiate()
	add_child(instancia)
	instancia.mudar_texto_do_pop_up("Cadastro efetuado com sucesso!", true)
	get_tree().paused = true

func cadastro_finalizado(usuario:String) -> void:
	coletor_usuario.set_text(usuario)
	if organizador_criar.is_visible_in_tree():
		organizador_criar.hide()
		organizador_login.show()

func pop_up_de_falha() -> void:
	var cena:PackedScene = load("res://Sistemas/Basicos/Client/Gerenciador de interfaces/Sub Cenas/pop_up.tscn")
	var instancia = cena.instantiate()
	add_child(instancia)
	instancia.mudar_texto_do_pop_up("falha ao criar o cadastro!", false)
	get_tree().paused = true

func pop_up_de_falha_de_login() -> void:
	var cena:PackedScene = load("res://Sistemas/Basicos/Client/Gerenciador de interfaces/Sub Cenas/pop_up.tscn")
	var instancia = cena.instantiate()
	add_child(instancia)
	instancia.mudar_texto_do_pop_up("usuario ou senha invalidos!", false)
	get_tree().paused = true
	
