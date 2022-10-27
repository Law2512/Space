#Meteorito.gd
class_name Meteorito
extends RigidBody2D

##Atributos Export
export var velLinealBase:Vector2 = Vector2(300.0, 300.0)
export var velAngBase:float = 3.0
export var hitpointsBase:float = 10.0

##Atributos
var hitpoints:float

##Metodos
func _ready() -> void:
	angular_velocity = velAngBase

##Constructor
func crear(pos: Vector2, dir: Vector2, tamanio: float) -> void:
	position = pos
	#Calcular masa, tamaño de Sprite y de colisionador
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	#radio = diametro / 2
	var radio:int = int($Sprite.texture.get_size().x / 2.3 * tamanio)
	var formaColision:CircleShape2D = CircleShape2D.new()
	formaColision.radius = radio
	$CollisionShape2D.shape = formaColision
	#Calcular velocidades
	linear_velocity = velLinealBase * dir
	angular_velocity = velAngBase / tamanio
	#Calcular hitpoints
	hitpoints = hitpointsBase * tamanio
	#Solo Debug
	print("hitpoints: ", hitpoints)
