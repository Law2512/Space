#Player.gd
class_name Player
extends NaveBase

##Atributos Export
export var potenciaMotor:int = 20
export var potenciaRotacion:int = 260
export var estelaMaxima:int = 150

##Atributos
var empuje:Vector2 = Vector2.ZERO
var dirRotacion:int = 0

##Atributos Onready
onready var laser:RayoLaser = $LaserBeam2D setget ,getLaser
onready var estela:estela = $EstelaInicio/Trail2D
onready var motorSFX:Motor = $MotorSFX
onready var escudo:Escudo = $Escudo setget ,getEscudo

##Setters y Getters
func getLaser() -> RayoLaser:
	return laser

func getEscudo() -> Escudo:
	return escudo

##Metodos
func _ready() -> void:
	DatosJuego.setPlayerActual(self)

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	apply_central_impulse(empuje.rotated(rotation))
	apply_torque_impulse(dirRotacion * potenciaRotacion)

func _process(delta: float) -> void:
	playerInput()

func _unhandled_input(event: InputEvent) -> void:
	if not estaInputActivo():
		return
	
	#Disparar Rayo
	if event.is_action_pressed("disparoSecundario"):
		laser.set_is_casting(true)
	
	if event.is_action_released("disparoSecundario"):
		laser.set_is_casting(false)
	
	#Control Estela y sonido motor
	if event.is_action_pressed("moverAdelante"):
		estela.setMaxPoints(estelaMaxima)
		motorSFX.sonidoON()
	elif event.is_action_pressed("moverAtras"):
		estela.setMaxPoints(0)
		motorSFX.sonidoON()
	
	if event.is_action_released("moverAtras") or event.is_action_released(("moverAdelante")):
		motorSFX.sonidoOFF()
	
	#Control Escudo
	if event.is_action_pressed("escudo") and not escudo.getEstaActivado():
		escudo.activar()

##Metodos Custom
func estaInputActivo() -> bool:
	if estadoActual in [ESTADO.MUERTO, ESTADO.SPAWN]:
		return false
	return true

func playerInput() -> void:
	if not estaInputActivo():
		return
	
	##Empuje
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
	
	##Disparo
	if Input.is_action_pressed("disparoPrincipal"):
		canion.setEstaDisparando(true)
	
	if Input.is_action_just_released("disparoPrincipal"):
		canion.setEstaDisparando(false)
