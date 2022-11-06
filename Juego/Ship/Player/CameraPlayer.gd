#CamaraPlayer.gd
class_name CamaraPlayer
extends CamaraJuego

##Atributos export
export var variacionZoom:float = 0.1
export var zoomMinimo:float = 0.8
export var zoomMaximo:float = 1.5

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoomIN"):
		controlarZoom(-variacionZoom)
	elif event.is_action_pressed("zoomOUT"):
		controlarZoom(variacionZoom)

##Metodos Custom
func controlarZoom(modZoom: float) -> void:
	zoom.x = clamp(zoom.x + modZoom, zoomMinimo, zoomMaximo)
	zoom.y = clamp(zoom.y + modZoom, zoomMinimo, zoomMaximo)
	zoomSuavizado(zoom.x, zoom.y, 0.15)
