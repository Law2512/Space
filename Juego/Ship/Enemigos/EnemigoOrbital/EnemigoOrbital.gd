#EnemigoOrbital.gd
class_name EnemigoOrbital
extends EnemigoBase

#Atributos
var baseDuenia:Node2D

##Atributos Export
export var rangoMaxAtaque: float = 800.0

##Metodos
func _ready() -> void:
	Eventos.connect("baseDestruida", self, "_on_baseDestruida")
	canion.setEstaDisparando(true)

func rotarHaciaPlayer() -> void:
	.rotarHaciaPlayer()
	if dirPlayer.length() > rangoMaxAtaque:
		canion.setEstaDisparando(false)
	else:
		canion.setEstaDisparando(true)

##Constructor
func crear(pos: Vector2, duenia: Node2D) -> void:
	global_position = pos
	baseDuenia = duenia

#Conexion Seniales Externas
func _on_baseDestruida(base: Node2D, _pos) -> void:
	if base == baseDuenia:
		destruir()
