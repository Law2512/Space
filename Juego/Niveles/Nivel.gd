#Nivel.gd
class_name Nivel
extends Node2D

##Atributos Export
export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var explosionMeteorito:PackedScene = null
export var sector_Meteoritos:PackedScene = null
export var enemigoInterceptor:PackedScene = null
export var releMasa:PackedScene = null
export var tiempoTransicionCamara:float = 2.0
export var tiempoLimite:int = 10

##Atributos Onready
onready var contenedorProyectiles:Node
onready var contenedorMeteoritos:Node
onready var contenedorSectorMeteoritos:Node
onready var contenedorEnemigos:Node
onready var camaraNivel:Camera2D = $CameraNivel
onready var camaraPlayer:Camera2D = $Player/CameraPlayer
onready var actualizadorTimer:Timer = $ActualizarTimer

##Atributos
var meteoritosTotales:int = 0
var player:Player = null
var numeroBasesEnemigas = 0

##Metodos
func _ready() -> void:
	Eventos.emit_signal("nivelIniciado")
	Eventos.emit_signal("actualizarTiempo", tiempoLimite)
	actualizadorTimer.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	conectarSeniales()
	crearContenedores()
	numeroBasesEnemigas = contabilizarBasesEnemigas()
	player = DatosJuego.getPlayerActual()

##Metodos Custom
func conectarSeniales() -> void:
	Eventos.connect("disparo", self, "onDisparo")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	Eventos.connect("spawnMeteorito", self, "_on_spawn_meteoritos")
	Eventos.connect("meteoritoDestruido", self, "_on_meteorito_destruido")
	Eventos.connect("naveSectorPeligro", self, "_on_naveSectorPeligro")
	Eventos.connect("baseDestruida", self, "_on_baseDestruida")
	Eventos.connect("spawnOrbital", self, "_on_spawnOrbital")

func destruirNivel() -> void:
	crearExplosion(
		player.global_position,
		8.0,
		2,
		1.5,
		Vector2(300.0, 200.0)
	)
	
	player.destruir()

func crearPosicionAleatoria(rangoHorizontal: float, rangoVertical: float) -> Vector2:
	randomize()
	var randX = rand_range(-rangoHorizontal, rangoHorizontal)
	var randY = rand_range(-rangoVertical, rangoVertical)
	
	return Vector2 (randX, randY)

func crearSectorMeteoritos(centroCamara:Vector2, numPeligro:int) -> void:
	meteoritosTotales = numPeligro
	var newSectorMeteoritos:SectorMeteoritos = sector_Meteoritos.instance()
	newSectorMeteoritos.crear(centroCamara, numPeligro)
	camaraNivel.global_position = centroCamara
	contenedorSectorMeteoritos.add_child(newSectorMeteoritos)
	camaraNivel.zoom = camaraPlayer.zoom
	camaraNivel.devolverZoomOriginal()
	transicionCamaras(
		camaraPlayer.global_position,
		camaraNivel.global_position,
		camaraNivel,
		tiempoTransicionCamara
	)

func crearSectorEnemigos(numEnemigos: int) -> void:
	for _i in range(numEnemigos):
		var newInterceptor:EnemigoInterceptor = enemigoInterceptor.instance()
		var spawnPos:Vector2 = crearPosicionAleatoria(1000.0, 800.0)
		newInterceptor.global_position = player.global_position + spawnPos
		contenedorEnemigos.add_child(newInterceptor)

func controlarMeteoritosRestantes() -> void:
	meteoritosTotales -= 1
	Eventos.emit_signal("cambioNumeroMeteoritos", meteoritosTotales)
	if meteoritosTotales == 0:
		contenedorSectorMeteoritos.get_child(0).queue_free()
		camaraPlayer.setPuedeHacerZoom(true)
		var zoomActual = camaraPlayer.zoom
		camaraPlayer.zoom = camaraNivel.zoom
		camaraPlayer.zoomSuavizado(zoomActual.x, zoomActual.y, 1.0)
		transicionCamaras(
			camaraNivel.global_position,
			camaraPlayer.global_position,
			camaraPlayer,
			tiempoTransicionCamara * 0.10
		)

func contabilizarBasesEnemigas() -> int:
	return $BasesEnemigas.get_child_count()

func crearRele() -> void:
	var newReleMasa:ReleMasa = releMasa.instance()
	var posAleatoria:Vector2 = crearPosicionAleatoria(400.0, 200.0)
	var margen:Vector2 = Vector2(600.0, 600.0)
	if posAleatoria.x < 0:
		margen.x *= -1
	if posAleatoria.y < 0:
		margen.y *= -1
	
	newReleMasa.global_position = player.global_position + (margen + posAleatoria)
	add_child(newReleMasa)

func transicionCamaras(desde: Vector2, hasta: Vector2, camaraActual: Camera2D, tiempoTransicion) -> void:
	$TweenCamara.interpolate_property(
		camaraActual,
		"global_position",
		desde,
		hasta,
		tiempoTransicionCamara,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	camaraActual.current = true
	$TweenCamara.start()

func crearContenedores() -> void:
	contenedorProyectiles = Node.new()
	contenedorProyectiles.name = "ContenedorProyectiles"
	add_child(contenedorProyectiles)
	contenedorMeteoritos = Node.new()
	contenedorMeteoritos.name = "ContenedorMeteoritos"
	add_child(contenedorMeteoritos)
	contenedorSectorMeteoritos = Node.new()
	contenedorSectorMeteoritos.name = "ContenedorSectorMeteoritos"
	add_child(contenedorSectorMeteoritos)
	contenedorEnemigos = Node.new()
	contenedorEnemigos.name = "ContenedorEnemigos"
	add_child(contenedorEnemigos)

func onDisparo(proyectil:Proyectil) -> void:
	contenedorProyectiles.add_child(proyectil)

func crearExplosion(
		posicion: Vector2,
		timer = _on_RestartTimer_timeout(),
		numero: int = 1,
		intervalo: float = 0.0,
		rangosAleatorios: Vector2 = Vector2(0.0, 0.0)
	) -> void:
			for i in range(numero):
				var newExplosion:Node2D = explosion.instance()
				newExplosion.global_position = posicion + crearPosicionAleatoria(
					rangosAleatorios.x,
					rangosAleatorios.y
					)
				add_child(newExplosion)
				yield(get_tree().create_timer(0.6), "timeout")
				newExplosion.queue_free()

##Conexion señales externas
func _on_nave_destruida(nave: Player, posicion: Vector2, num_explosiones: int) -> void:
	if nave is Player:
		transicionCamaras(
			posicion,
			posicion + crearPosicionAleatoria(-200.0, 200.0),
			camaraNivel,
			tiempoTransicionCamara
		)
		
		$RestartTimer.start()
	crearExplosion(posicion, 1.0, num_explosiones, 0.6, Vector2(100.0, 50.0))

func _on_baseDestruida(_base: Node2D, posPartes: Array) -> void:
	for posicion in posPartes:
		crearExplosion(posicion)
		yield(get_tree().create_timer(0.5), "timeout")
	
	numeroBasesEnemigas -= 1
	if numeroBasesEnemigas == 0:
		crearRele()

func _on_meteorito_destruido(pos: Vector2) -> void:
	var newExplosionMet:ExplosionMeteorito = explosionMeteorito.instance()
	newExplosionMet.global_position = pos
	add_child(newExplosionMet)
	
	controlarMeteoritosRestantes()

func _on_spawn_meteoritos(posSpawn: Vector2, dirMeteorito: Vector2, tamanio: float) -> void:
	var newMeteorito:Meteorito = meteorito.instance()
	newMeteorito.crear(
		posSpawn,
		dirMeteorito,
		tamanio
	)
	contenedorMeteoritos.add_child(newMeteorito)

func _on_naveSectorPeligro(centroCam:Vector2, tipoPeligro:String, numeroPeligros:int) -> void:
	if tipoPeligro == "Meteorito":
		crearSectorMeteoritos(centroCam, numeroPeligros)
		Eventos.emit_signal("cambioNumeroMeteoritos", numeroPeligros)
	elif tipoPeligro == "Enemigo":
		crearSectorEnemigos(numeroPeligros)

func _on_spawnOrbital(enemigo: EnemigoOrbital) -> void:
	contenedorEnemigos.add_child(enemigo)

##Señales Internas
func _on_TweenCamara_tween_completed(object: Object, key: NodePath) -> void:
	if object.name == "CameraPlayer":
		object.global_position = $Player.global_position

func _on_RestartTimer_timeout() -> void:
	Eventos.emit_signal("nivelTerminado")
	yield(get_tree().create_timer(1.0),"timeout")
	get_tree().reload_current_scene()

func _on_ActualizarTimer_timeout() -> void:
	tiempoLimite -= 1
	Eventos.emit_signal("actualizarTiempo", tiempoLimite)
	if tiempoLimite == 0:
		destruirNivel()
