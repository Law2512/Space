#Nivel.gd
class_name Nivel
extends Node2D

##Atributos Onready
onready var contenedorProyectiles:Node

##Metodos
func _ready() -> void:
	Eventos.connect("disparo", self, "onDisparo")
	crearContenedores()

##Metodos Custom
func conectarSeniales() -> void:
	Eventos.connect("disparo", self, "onDisparo")

func crearContenedores() -> void:
	contenedorProyectiles = Node.new()
	contenedorProyectiles.name = "ContenedorProyectiles"
	add_child(contenedorProyectiles)

func onDisparo(proyectil:Proyectil) -> void:
	contenedorProyectiles.add_child(proyectil)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
