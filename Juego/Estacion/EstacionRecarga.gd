#EstacionRecarga.gd
class_name EstacionRecarga
extends Node2D

##Atributos export
export var energia:float = 6.0
export var radioEnergiaEntregada:float = 0.05

##Atributos Onready
onready var cargaSFX:AudioStreamPlayer = $CargaSFX
onready var vacioSFX:AudioStreamPlayer = $VacioSFX

##Atributos
var navePlayer:Player = null
var playerEnZona:bool = false

##Metodos
func _unhandled_input(event: InputEvent) -> void:
	if not puedeRecargar(event):
		return
	
	controlarEnergia()
	
	if event.is_action("recargaEscudo"):
		navePlayer.getEscudo().controlarEnergia(radioEnergiaEntregada)
	elif event.is_action("recargaLaser"):
		navePlayer.getLaser().controlarEnergia(radioEnergiaEntregada)

##Metodos Custom
func puedeRecargar(event: InputEvent ) -> bool:
	var hayInput = event.is_action("recargaEscudo") or event.is_action("recargaLaser")
	if hayInput and playerEnZona and energia > 0.0:
		if !cargaSFX.playing:
			cargaSFX.play()
		return true
	
	return false

func controlarEnergia() -> void:
	energia -= radioEnergiaEntregada
	if energia <= 0.0:
		vacioSFX.play()
	print("ENERGIA ESTACION: ")

##Señales internas
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

func _on_AreaRecarga_body_entered(body: Node) -> void:
	playerEnZona = true
	if body is Player:
		navePlayer = body

func _on_AreaRecarga_body_exited(body: Node) -> void:
	playerEnZona = false
	body.set_gravity_scale(0.0)
