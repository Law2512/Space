#Player.gd
class_name Player
extends RigidBody2D

##Atributos Export
export var potenciaMotor:int = 20
export var potenciaRotacion:int = 280

##Atributos
var empuje:Vector2 = Vector2.ZERO
var dirRotacion:int = 0

##Metodos
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dirRotacion * potenciaRotacion)

func _process(delta: float) -> void:
	playerInput()

##Custom Metods 
func playerInput() -> void:
	empuje = Vector2.ZERO
	if Input.is_action_pressed("moverAdelante"):
		empuje = Vector2(potenciaMotor, 0)
	elif Input.is_action_pressed("moverAtras"):
		empuje = Vector2(-potenciaMotor, 0)
	
	##Rotacion
	dirRotacion = 0
	if Input.is_action_pressed("moverAntiHorario"):
		dirRotacion -= 1
	elif Input.is_action_pressed("moverHorario"):
		dirRotacion += 1
