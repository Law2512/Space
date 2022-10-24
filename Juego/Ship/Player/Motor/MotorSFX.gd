#MotorGD
class_name Motor
extends AudioStreamPlayer2D

export var tiempoTransicion:float = 0.6
export var volumenApagado:float = -30.0

onready var tweenSonido:Tween = $Tween

var volumenOriginal:float

func _ready() -> void:
	volumenOriginal = volume_db
	volume_db = volumenApagado

func sonidoON() -> void:
	if not playing:
		play()
	
	efectoTransicion(volume_db, volumenOriginal)

func sonidoOFF() -> void:
	efectoTransicion(volume_db, volumenApagado)

func efectoTransicion(desdeVol: float, hastaVol: float) -> void:
	tweenSonido.interpolate_property(
		self,
		"volume_db",
		desdeVol,
		hastaVol,
		tiempoTransicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	tweenSonido.start()
