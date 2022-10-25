#Nivel.gd
class_name Nivel
extends Node2D

##Atributos Export
export var explosion:PackedScene = null

##Atributos Onready
onready var contenedorProyectiles:Node

##Metodos
func _ready() -> void:
	Eventos.connect("disparo", self, "onDisparo")
	crearContenedores()

##Metodos Custom
func conectarSeniales() -> void:
	Eventos.connect("disparo", self, "onDisparo")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")

func _on_nave_destruida(posicion: Vector2, num_explosiones: int) -> void:
	var newExplosion:Node2D = explosion.instance()
	newExplosion.global_position = posicion
	add_child(newExplosion)
	yield(get_tree().create_timer(0.6), "timeout")

func crearContenedores() -> void:
	contenedorProyectiles = Node.new()
	contenedorProyectiles.name = "ContenedorProyectiles"
	add_child(contenedorProyectiles)

func onDisparo(proyectil:Proyectil) -> void:
	contenedorProyectiles.add_child(proyectil)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
