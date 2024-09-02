class_name INTERFACE_DE_ABERTURA_REFERENCIAS
extends Control

#Efeito Parallax:
@onready var plano_de_fundo_parallax: ParallaxBackground = $BordaEfundo/Centralizador/PlanoDeFundoParallax
@onready var camada_1:ParallaxLayer = $BordaEfundo/Centralizador/PlanoDeFundoParallax/Camada1
@onready var imagem_camada_1:TextureRect = $BordaEfundo/Centralizador/PlanoDeFundoParallax/Camada1/ImagemCamada1
@onready var camada_2:ParallaxLayer = $BordaEfundo/Centralizador/PlanoDeFundoParallax/Camada2
@onready var imagem_camada_2:TextureRect = $BordaEfundo/Centralizador/PlanoDeFundoParallax/Camada2/ImagemCamada2
@onready var camada_3:ParallaxLayer = $BordaEfundo/Centralizador/PlanoDeFundoParallax/Camada3
@onready var imagem_camada_3:TextureRect = $BordaEfundo/Centralizador/PlanoDeFundoParallax/Camada3/ImagemCamada3
@onready var camada_4:ParallaxLayer = $BordaEfundo/Centralizador/PlanoDeFundoParallax/Camada4
@onready var imagem_camada_4:TextureRect = $BordaEfundo/Centralizador/PlanoDeFundoParallax/Camada4/ImagemCamada4
@onready var camada_5:ParallaxLayer = $BordaEfundo/Centralizador/PlanoDeFundoParallax/Camada5
@onready var imagem_camada_5:TextureRect = $BordaEfundo/Centralizador/PlanoDeFundoParallax/Camada5/ImagemCamada5

#Botões que controlam a interface de abertura:
@onready var botao_creditos:TextureButton = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorDeBotoes/BotaoCreditos
@onready var botao_criar_conta:TextureButton = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorDeBotoes/BotaoCriarConta
@onready var botao_opcoes:TextureButton = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorDeBotoes/BotaoOpcoes
@onready var botao_patch_notes:TextureButton = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorDeBotoes/BotaoPatchNotes
@onready var botao_sair:TextureButton = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorDeBotoes/BotaoSair

#Controladores de visibilidade de menu:
@onready var organizador_login:VBoxContainer = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorLogin
@onready var organizador_creditos:VBoxContainer = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCreditos
@onready var organizador_criar:VBoxContainer = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCriar
@onready var organizador_patch_notes:VBoxContainer = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorPatchNotes

#interface de login:
@onready var coletor_usuario:LineEdit = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorLogin/ColetorUsuario
@onready var coletor_senha:LineEdit = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorLogin/ColetorSenha
@onready var botao_confirmar:TextureButton = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorLogin/BotaoConfirmar
@onready var verificador_conectar_automaticamente:CheckBox = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorLogin/VerificadorConectarAutomaticamente

#interface de creditos:
@onready var texto_creditos:RichTextLabel = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCreditos/GeradorDeScroll/TextoCreditos
@onready var botao_voltar_creditos:TextureButton = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCreditos/BotaoVoltarCreditos

#interface de criar usuario:
@onready var coletor_usuario_criar:LineEdit = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCriar/OrganizadorUsuario/ColetorUsuarioCriar
@onready var coletor_senha_criar:LineEdit = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCriar/OrganizadorSenha/ColetorSenhaCriar
@onready var coletor_email_criar:LineEdit = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCriar/OrganizadorEmail/ColetorEmailCriar
@onready var coletor_nick_criar:LineEdit = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCriar/OrganizadorNick/ColetorNickCriar
@onready var verificador_termos:CheckBox = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCriar/VerificadorTermos
@onready var botao_criar:TextureButton = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCriar/OrganizadorBotoes/BotaoCriar
@onready var botao_cancelar:TextureButton = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorCriar/OrganizadorBotoes/BotaoCancelar

#interface de opções:

#interface de patch notes:
@onready var texto_patch_notes:RichTextLabel = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorPatchNotes/GeradorDeScroll/TextoPatchNotes
@onready var botao_voltar_patch_notes:TextureButton = $BordaEfundo/Centralizador/OrganizadorDeMioloVertical/OrganizadorDeMioloHorizontal/OrganizadorColetadorDeInfo/OrganizadorHorizontal/OrganizadorPatchNotes/BotaoVoltarPatchNotes

func _ready():
	login_automatico()

func quando_botao_creditos_pressionado() -> void:
	organizador_creditos.visible = !organizador_creditos.visible
	organizador_criar.visible = false
	#organizador_opcoes.visible = false
	organizador_login.visible = !organizador_login.visible
	organizador_patch_notes.visible = false
	if organizador_creditos.is_visible_in_tree():
		organizador_login.visible = false
	else:
		organizador_login.visible = true
	limpar_campos_criar()
	if !verificador_conectar_automaticamente.button_pressed:
		limpar_campos_login()

func quando_botao_criar_conta_pressionado() -> void:
	organizador_criar.visible = !organizador_criar.visible
	organizador_creditos.visible = false
	#organizador_opcoes.visible = false
	organizador_patch_notes.visible = false
	if organizador_criar.is_visible_in_tree():
		organizador_login.visible = false
	else:
		organizador_login.visible = true
	limpar_campos_criar()
	if !verificador_conectar_automaticamente.button_pressed:
		limpar_campos_login()

#func quando_botao_opcoes_pressionado() -> void:
	#organizador_opcoes.visible = !organizador_opcoes.visible
	#organizador_creditos.visible = false
	#organizador_criar.visible = false
	#organizador_patch_notes.visible = false
	#if organizador_opcoes.is_visible_in_tree():
	#	organizador_login.visible = false
	#else:
	#	organizador_login.visible = true
	#limpar_campos_criar()
	#if !verificador_conectar_automaticamente.button_pressed:
	#	limpar_campos_login()

func quando_botao_patch_notes_pressionado() -> void:
	organizador_patch_notes.visible = !organizador_patch_notes.visible
	organizador_creditos.visible = false
	#organizador_opcoes.visible = false
	organizador_criar.visible = false
	if organizador_patch_notes.is_visible_in_tree():
		organizador_login.visible = false
	else:
		organizador_login.visible = true
	limpar_campos_criar()
	if !verificador_conectar_automaticamente.button_pressed:
		limpar_campos_login()

func quando_botao_sair_pressionado() -> void:
	get_tree().quit()

func quando_botao_confirmar_pressionado() -> void:
	var usuario:String = coletor_usuario.get_text()
	var senha:String = coletor_senha.get_text()
	var verificador:bool = verificador_conectar_automaticamente.button_pressed
	limpar_campos_criar()
	if !verificador:
		limpar_campos_login()
	SERVER.enviando.autenticar_usuario(usuario, senha, verificador)

func limpar_campos_login() -> void:
	coletor_usuario.clear()
	coletor_senha.clear()

func quando_botao_voltar_creditos_pressionado() -> void:
	organizador_patch_notes.visible = false
	organizador_creditos.visible = false
	#organizador_opcoes.visible = false
	organizador_login.visible = true
	organizador_criar.visible = false
	limpar_campos_criar()
	if !verificador_conectar_automaticamente.button_pressed:
		limpar_campos_login()

func quando_botao_criar_pressionado() -> void:
	var usuario:String = coletor_usuario_criar.get_text()
	var senha:String = coletor_senha_criar.get_text()
	var email:String = coletor_email_criar.get_text()
	var nick:String = coletor_nick_criar.get_text()
	SERVER.enviando.criar_usuario(usuario, senha, email, nick)

func quando_botao_cancelar_pressionado() -> void:
	organizador_patch_notes.visible = false
	organizador_creditos.visible = false
	#organizador_opcoes.visible = false
	organizador_login.visible = true
	organizador_criar.visible = false
	limpar_campos_criar()
	if !verificador_conectar_automaticamente.button_pressed:
		limpar_campos_login()

func limpar_campos_criar() -> void:
	coletor_email_criar.clear()
	coletor_nick_criar.clear()
	coletor_senha_criar.clear()
	coletor_usuario_criar.clear()
	verificador_termos.button_pressed = false

func quando_botao_voltar_patch_notes_pressionado() -> void:
	organizador_patch_notes.visible = false
	organizador_creditos.visible = false
	#organizador_opcoes.visible = false
	organizador_login.visible = true
	organizador_criar.visible = false
	limpar_campos_criar()
	if !verificador_conectar_automaticamente.button_pressed:
		limpar_campos_login()

func _process(_delta):
	liberar_botao_confirmar()
	liberar_botao_criar()

func conferir_email(email:String) -> bool:
	if email.contains("@") && email.length() > 3 && email.count("@") == 1:
		var idx = email.find("@")
		if email.length() > idx + 3:
			return true
	return false

func liberar_botao_confirmar() -> void:
	if organizador_login.is_visible_in_tree():
		if !coletor_usuario.get_text() || coletor_usuario.get_text().length() < 3:
			botao_confirmar.set_disabled(true)
			return
		if !coletor_senha.get_text() || coletor_senha.get_text().length() < 3:
			botao_confirmar.set_disabled(true)
			return
		botao_confirmar.set_disabled(false)

func liberar_botao_criar() -> void:
	if organizador_criar.is_visible_in_tree():
		if !coletor_usuario_criar.get_text() || coletor_usuario_criar.get_text().length() < 3:
			botao_criar.set_disabled(true)
			return
		if !coletor_senha_criar.get_text() || coletor_senha_criar.get_text().length() < 3:
			botao_criar.set_disabled(true)
			return
		if !coletor_email_criar.get_text() || !conferir_email(coletor_email_criar.get_text()):
			botao_criar.set_disabled(true)
			return
		if !coletor_nick_criar.get_text():
			botao_criar.set_disabled(true)
			return
		if !verificador_termos.button_pressed:
			botao_criar.set_disabled(true)
			return
		botao_criar.set_disabled(false)

func login_automatico() -> void:
	if DATA.loginAutomatico.is_empty():
		return
	coletor_usuario.set_text(DATA.loginAutomatico["usuario"])
	coletor_senha.set_text(DATA.loginAutomatico["senha"])
	verificador_conectar_automaticamente.button_pressed = DATA.loginAutomatico["verificador"]
	await get_tree().create_timer(0.5).timeout
	botao_confirmar.pressed.emit()

