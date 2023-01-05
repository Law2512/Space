#MiniMapa.gd
extends MarginContainer

##Atributos Export
export var escalaZoom:float = 4.0
export var tiempoVisible:float = 5.0

##Atributos
var escalaGrilla:Vector2
var player:Player = null
var estaVisible:bool = true setget setEstaVisible

##Atributos Onready
onready var zonaRenderizada:TextureRect = $Cuadro/ContenedorIconos/ZonaRenderizado
onready var iconoPlayer:Sprite = $Cuadro/ContenedorIconos/ZonaRenderizado/IconoPlayer
onready var iconoBaseEnemiga:Sprite = $Cuadro/ContenedorIconos/ZonaRenderizado/IconoBaseEnemiga
onready var iconoEstacionRecarga:Sprite = $Cuadro/ContenedorIconos/ZonaRenderizado/IconoEstacionRecarga
onready var iconoInterceptor:Sprite = $Cuadro/ContenedorIconos/ZonaRenderizado/IconoInterceptor
onready var iconoRele:Sprite = $Cuadro/ContenedorIconos/ZonaRenderizado/IconoRele
onready var timerVisible:Timer = $TimerVisibilidad
onready var tweenVisible:Tween = $TweenVisibilidad

onready var itemsMiniMapa:Dictionary = {} 

##Setters y Getters
func setEstaVisible(hacerVisible: bool) -> void:
	if hacerVisible:
		timerVisible.start()
	
	estaVisible = hacerVisible
	
	tweenVisible.interpolate_property(
		self,
		"modulate",
		Color(1, 1, 1, not hacerVisible),
		Color(1, 1, 1, hacerVisible),
		0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	
	tweenVisible.start()

##Metodos
func _ready() -> void:
	set_process(false)
	iconoPlayer.position = zonaRenderizada.rect_size * 0.5
	escalaGrilla = zonaRenderizada.rect_size / (get_viewport_rect().size * escalaZoom)
	conectarSeniales()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("minimapa"):
		setEstaVisible(not estaVisible)

func _process(_delta: float) -> void:
	if not player:
		return
	
	iconoPlayer.rotation_degrees = player.rotation_degrees + 90
	modificarPosicionIconos()

##Metodos Custom
func conectarSeniales() -> void:
	Eventos.connect("nivelIniciado", self, "_on_nivelIniciado")
	Eventos.connect("nave_destruida", self, "_on_naveDestruida")
	Eventos.connect("minimapaObjetoCreado", self, "obtenerObjetosMinimapa")
	Eventos.connect("minimapaObjetoDestruido", self, "quitarIcono")

func obtenerObjetosMinimapa() -> void:
	var objetosEnVentana:Array = get_tree().get_nodes_in_group("minimapa")
	for objeto in objetosEnVentana:
		if not itemsMiniMapa.has(objeto):
			var spriteIcono:Sprite
			if objeto is BaseEnemiga:
				spriteIcono = iconoBaseEnemiga.duplicate()
			elif objeto is EstacionRecarga:
				spriteIcono = iconoEstacionRecarga.duplicate()
			elif objeto is EnemigoInterceptor:
				spriteIcono = iconoInterceptor.duplicate()
			elif objeto is ReleMasa:
				spriteIcono = iconoRele.duplicate()
			
			itemsMiniMapa[objeto] = spriteIcono
			itemsMiniMapa[objeto].visible = true
			zonaRenderizada.add_child(itemsMiniMapa[objeto])

func modificarPosicionIconos() -> void:
	for item in itemsMiniMapa:
		var itemIcono:Sprite = itemsMiniMapa[item]
		var offsetPos:Vector2 = item.position - player.position
#		var posIcono:Vector2 = offsetPos * escalaGrilla + (zonaRenderizada.rect_size * 0.5)
		var posIcono:Vector2 = offsetPos * escalaGrilla + iconoPlayer.position
		posIcono.x = clamp(posIcono.x, 0, zonaRenderizada.rect_size.x)
		posIcono.y = clamp(posIcono.y, 0, zonaRenderizada.rect_size.y)
		itemIcono.position = posIcono
		
		if zonaRenderizada.get_rect().has_point(posIcono - zonaRenderizada.rect_position):
			itemIcono.scale = Vector2(0.5, 0.5)
		else: 
			itemIcono.scale = Vector2(0.3, 0.3)

func quitarIcono(objeto: Node2D) -> void:
	if objeto in itemsMiniMapa:
		itemsMiniMapa[objeto].queue_free()
		itemsMiniMapa.erase(objeto)

##Conexion Seniales Externas
func _on_nivelIniciado() -> void:
	player = DatosJuego.getPlayerActual()
	obtenerObjetosMinimapa()
	set_process(true)

func _on_naveDestruida(nave: NaveBase, _posicion, _explosiones) -> void:
	if nave is Player:
		player = null

##Conexion Seniales Internas
func _on_TimerVisibilidad_timeout() -> void:
	if estaVisible:
		setEstaVisible(false)
