#Nivel.gd
class_name Nivel
extends Node2D

##Atributos Export
export var explosion:PackedScene = null
export var meteorito:PackedScene = null
export var explosionMeteorito:PackedScene = null

##Atributos Onready
onready var contenedorProyectiles:Node
onready var contenedorMeteoritos:Node

##Metodos
func _ready() -> void:
	Eventos.connect("disparo", self, "onDisparo")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	Eventos.connect("spawnMeteorito", self, "_on_spawn_meteoritos")
	Eventos.connect("meteoritoDestruido", self, "_on_meteorito_destruido")
	crearContenedores()

##Metodos Custom
func conectarSeniales() -> void:
	Eventos.connect("disparo", self, "onDisparo")

func _on_nave_destruida(posicion: Vector2, num_explosiones: int) -> void:
	for i in range(num_explosiones):
		var newExplosion:Node2D = explosion.instance()
		newExplosion.global_position = posicion
		add_child(newExplosion)
		yield(get_tree().create_timer(0.6), "timeout")

func _on_meteorito_destruido(pos: Vector2) -> void:
	var newExplosion:ExplosionMeteorito = explosionMeteorito.instance()
	newExplosion.global_position = pos
	add_child(newExplosion	)

func crearContenedores() -> void:
	contenedorProyectiles = Node.new()
	contenedorProyectiles.name = "ContenedorProyectiles"
	add_child(contenedorProyectiles)
	contenedorMeteoritos = Node.new()
	contenedorMeteoritos.name = "ContenedorMeteoritos"
	add_child(contenedorMeteoritos)

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
