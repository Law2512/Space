#CamaraJuego.gd
class_name CamaraJuego
extends Camera2D

##Atributos
var zoomOriginal:Vector2
var puedeHacerZoom:bool = true setget setPuedeHacerZoom

##Atributos onready
onready var tweenZoom:Tween = $TweenZoom
	
##Setters y Getters
func setPuedeHacerZoom(puede: bool) -> void:
	puedeHacerZoom = puede

##Metodos
func _ready() -> void:
	zoomOriginal = zoom

##Metodos Custom
func devolverZoomOriginal() -> void:
	puedeHacerZoom = false
	zoomSuavizado(zoomOriginal.x, zoomOriginal.y, 1.0)

func zoomSuavizado(nuevoZoomX: float, nuevoZoomY: float, tiempoTransicion: float) -> void:
	tweenZoom.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(nuevoZoomX, nuevoZoomY),
		tiempoTransicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tweenZoom.start()
