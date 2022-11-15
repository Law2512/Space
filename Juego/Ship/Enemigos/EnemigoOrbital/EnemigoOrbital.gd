#EnemigoOrbital.gd
class_name EnemigoOrbital
extends EnemigoBase

#Atributos
var baseDuenia:Node2D
var ruta:Path2D
var pathFollow:PathFollow2D

##Atributos Export
export var rangoMaxAtaque: float = 800.0
export var velocidad:float = 400.0

##Atributos Onready 
onready var detectorBase:RayCast2D = $DetectorBase

##Metodos
func _ready() -> void:
	Eventos.connect("baseDestruida", self, "_on_baseDestruida")
	canion.setEstaDisparando(true)

func _process(delta: float) -> void: 
	pathFollow.offset += velocidad * delta
	position = pathFollow.global_position

##Metodos Custom
func rotarHaciaPlayer() -> void:
	.rotarHaciaPlayer()
	if dirPlayer.length() > rangoMaxAtaque or detectorBase.is_colliding():
		canion.setEstaDisparando(false)
	else:
		canion.setEstaDisparando(true)

##Constructor
func crear(pos: Vector2, duenia: Node2D, rutaDuenia: Path2D) -> void:
	global_position = pos
	baseDuenia = duenia
	ruta = rutaDuenia
	pathFollow = PathFollow2D.new()
	ruta.add_child(pathFollow)

#Conexion Seniales Externas
func _on_baseDestruida(base: Node2D, _pos) -> void:
	if base == baseDuenia:
		destruir()
