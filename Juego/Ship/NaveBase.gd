#NaveBase.gd
class_name NaveBase
extends RigidBody2D

##Enums
enum ESTADO {SPAWN, VIVO, INVENCIBLE, MUERTO}

##Atributos Export
export var hitpoints:float = 20.0

##Atributos Onready
onready var canion:Canion = $Canion
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var impactoSFX:AudioStreamPlayer2D = $impactoSFX
onready var barraSalud:ProgressBar = $BarraSalud

##Atributos
var estadoActual:int = ESTADO.SPAWN

##Metodos
func _ready() -> void:
	barraSalud.setValores(hitpoints)
	controlarEstados(estadoActual)

##Custom Metods 
func recibirDanio(danio: float) -> void:
	hitpoints -= danio
	if hitpoints <= 0:
		destruir()
	
	barraSalud.controlarBarra(hitpoints, true)
	impactoSFX.play()

func controlarEstados(nuevoEstado: int) -> void:
	match nuevoEstado:
		ESTADO.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.setPuedeDisparar(false)
		ESTADO.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.setPuedeDisparar(true)
		ESTADO.INVENCIBLE:
			colisionador.set_deferred("disabled", true)
		ESTADO.MUERTO:
			colisionador.set_deferred("disabled", true)
			canion.setPuedeDisparar(false)
			Eventos.emit_signal("nave_destruida", self, global_position, 3)
			queue_free()
		_:
			printerr("Error de estado")
	
	estadoActual = nuevoEstado

func destruir() -> void:
	controlarEstados(ESTADO.MUERTO)

##Señales internas
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlarEstados(ESTADO.VIVO)

func _on_body_entered(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()
