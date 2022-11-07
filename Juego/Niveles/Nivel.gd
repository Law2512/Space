#Nivel.gd
class_name Nivel
extends Node2D

##Atributos Export
export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var explosionMeteorito:PackedScene = null
export var sector_Meteoritos:PackedScene = null
export var tiempoTransicionCamara:int = 1

##Atributos Onready
onready var contenedorProyectiles:Node
onready var contenedorMeteoritos:Node
onready var contenedorSectorMeteoritos:Node
onready var camaraNivel:Camera2D = $CameraNivel
onready var camaraPlayer:Camera2D = $Player/CameraPlayer

##Atributos
var meteoritosTotales:int = 0

##Metodos
func _ready() -> void:
	conectarSeniales()
	crearContenedores()

##Metodos Custom
func conectarSeniales() -> void:
	Eventos.connect("disparo", self, "onDisparo")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	Eventos.connect("spawnMeteorito", self, "_on_spawn_meteoritos")
	Eventos.connect("meteoritoDestruido", self, "_on_meteorito_destruido")
	Eventos.connect("naveSectorPeligro", self, "_on_naveSectorPeligro")

func crearPosicionAleatoria(rangoHorizontal: float, rangoVertical: float) -> Vector2:
	randomize()
	var randX = rand_range(-rangoHorizontal, rangoHorizontal)
	var randY = rand_range(-rangoVertical, rangoVertical)
	
	return Vector2 (randX, randY)

func _on_naveSectorPeligro(centroCam:Vector2, tipoPeligro:String, numeroPeligros:int) -> void:
	if tipoPeligro == "Meteorito":
		crearSectorMeteoritos(centroCam, numeroPeligros)
	elif tipoPeligro == "Enemigo":
		pass

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

func controlarMeteoritosRestantes() -> void:
	meteoritosTotales -= 1
	print(meteoritosTotales)
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

func _on_nave_destruida(nave: Player, posicion: Vector2, num_explosiones: int) -> void:
	if nave is Player:
		transicionCamaras(
			posicion,
			posicion + crearPosicionAleatoria(-200.0, 200.0),
			camaraNivel,
			tiempoTransicionCamara
		)
	for i in range(num_explosiones):
		var newExplosion:Node2D = explosion.instance()
		newExplosion.global_position = posicion + crearPosicionAleatoria(100.0, 50.0)
		add_child(newExplosion)
		yield(get_tree().create_timer(0.6), "timeout")

func _on_meteorito_destruido(pos: Vector2) -> void:
	var newExplosionMet:ExplosionMeteorito = explosionMeteorito.instance()
	newExplosionMet.global_position = pos
	add_child(newExplosionMet)
	
	controlarMeteoritosRestantes()

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

func onDisparo(proyectil:Proyectil) -> void:
	contenedorProyectiles.add_child(proyectil)

##Conexion señales externas
func _on_spawn_meteoritos(posSpawn: Vector2, dirMeteorito: Vector2, tamanio: float) -> void:
	var newMeteorito:Meteorito = meteorito.instance()
	newMeteorito.crear(
		posSpawn,
		dirMeteorito,
		tamanio
	)
	contenedorMeteoritos.add_child(newMeteorito)

##Señales Internas
func _on_TweenCamara_tween_completed(object: Object, key: NodePath) -> void:
	if object.name == "CameraPlayer":
		object.global_position = $Player.global_position
