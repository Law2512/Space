#Meteorito.gd
class_name Meteorito
extends RigidBody2D

##Atributos Export
export var velLinealBase:Vector2 = Vector2(300.0, 300.0)
export var velAngBase:float = 3.0
export var hitpointsBase:float = 10.0

##Atributos
var hitpoints:float
var estaEnSector:bool = true setget setEstaEnSector
var posSpawnOriginal:Vector2
var velSpawnOriginal:Vector2
var estaDestruido:bool = false

##Setters y Getters
func setEstaEnSector(valor: bool) -> void:
	estaEnSector = valor

##Metodos
func _ready() -> void:
	angular_velocity = velAngBase

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if estaEnSector:
		return
	
	var miTransform := state.get_transform()
	miTransform.origin = posSpawnOriginal
	linear_velocity = velSpawnOriginal
	state.set_transform(miTransform)
	estaEnSector = true	

##Metodos Custom
func recibirDanio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints <= 0 and not estaDestruido:
		estaDestruido = true
		destruir()
	
	$AnimationPlayer.play("Daño")

func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("meteoritoDestruido", global_position)
	queue_free()

func aleatorizarVelocidad() -> float:
	randomize()
	return rand_range(1.1, 1.4)

##Constructor
func crear(pos: Vector2, dir: Vector2, tamanio: float) -> void:
	position = pos
	posSpawnOriginal = position
	#Calcular masa, tamaño de Sprite y de colisionador
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	#radio = diametro / 2
	var radio:int = int($Sprite.texture.get_size().x / 2.3 * tamanio)
	var formaColision:CircleShape2D = CircleShape2D.new()
	formaColision.radius = radio
	$CollisionShape2D.shape = formaColision
	#Calcular velocidades
	linear_velocity = (velLinealBase * dir / tamanio) * aleatorizarVelocidad()
	velSpawnOriginal = linear_velocity
	angular_velocity = (velAngBase / tamanio) * aleatorizarVelocidad()
	#Calcular hitpoints
	hitpoints = hitpointsBase * tamanio
	#Solo Debug
	print("hitpoints: ", hitpoints)

