#EnemigoInterceptor.gd
class_name EnemigoInterceptor
extends EnemigoBase

##Enums
enum ESTADO_IA {IDLE, ATACANDOQ, ATACANDOP, PERSECUCION}

##Atributos Export
export var potenciaMax:float = 800.0

##Atributos
var estadoIAActual:int = ESTADO_IA.IDLE
var potenciaActual:float = 0.0

##Metodos
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	linear_velocity += dirPlayer.normalized() * potenciaActual * state.get_step()
	
	linear_velocity.x = clamp(linear_velocity.x, -potenciaMax, potenciaMax)
	linear_velocity.y = clamp(linear_velocity.y, -potenciaMax, potenciaMax)

##Metodos Custom
func controladorEstadosIa(nuevoEstado: int) -> void:
	match nuevoEstado:
		ESTADO_IA.IDLE:
			canion.setEstaDisparando(false)
			potenciaActual = 0.0
		ESTADO_IA.ATACANDOQ:
			canion.setEstaDisparando(true)
			potenciaActual = 0.0
		ESTADO_IA.ATACANDOP:
			canion.setEstaDisparando(true)
			potenciaActual = potenciaMax
		ESTADO_IA.PERSECUCION:
			canion.setEstaDisparando(false)
			potenciaActual = potenciaMax
		_:
			printerr("Error de estado")
	
	estadoIAActual = nuevoEstado


func _on_AreaDisparo_body_entered(body: Node) -> void:
	controladorEstadosIa(ESTADO_IA.ATACANDOP)


func _on_AreaDisparo_body_exited(body: Node) -> void:
	controladorEstadosIa(ESTADO_IA.PERSECUCION)


func _on_AreaDeteccion_body_entered(body: Node) -> void:
	controladorEstadosIa(ESTADO_IA.ATACANDOQ)


func _on_AreaDeteccion_body_exited(body: Node) -> void:
	controladorEstadosIa(ESTADO_IA.ATACANDOP)
