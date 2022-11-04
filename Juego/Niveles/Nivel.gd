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

func _on_naveSectorPeligro(centroCam:Vector2, tipoPeligro:String, numeroPeligros:int) -> void:
	if tipoPeligro == "Meteorito":
		crearSectorMeteoritos(centroCam, numeroPeligros)
	elif tipoPeligro == "Enemigo":
		pass

func crearSectorMeteoritos(centroCamara:Vector2, numPeligro:int) -> void:
	var newSectorMeteoritos:SectorMeteoritos = sector_Meteoritos.instance()
	newSectorMeteoritos.crear(centroCamara, numPeligro)
	camaraNivel.global_position = centroCamara
	contenedorSectorMeteoritos.add_child(newSectorMeteoritos)
	transicionCamaras(
		$Player/CameraPlayer.global_position,
		camaraNivel.global_position,
		camaraNivel
	)

func transicionCamaras(desde: Vector2, hasta: Vector2, camaraActual: Camera2D) -> void:
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

func _on_nave_destruida(posicion: Vector2, num_explosiones: int) -> void:
	for i in range(num_explosiones):
		var newExplosion:Node2D = explosion.instance()
		newExplosion.global_position = posicion
		add_child(newExplosion)
		yield(get_tree().create_timer(0.6), "timeout")

func _on_meteorito_destruido(pos: Vector2) -> void:
	var newExplosion:ExplosionMeteorito = explosionMeteorito.instance()
	newExplosion.global_position = pos
	add_child(newExplosion)

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
