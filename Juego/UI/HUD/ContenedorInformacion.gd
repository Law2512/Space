#ContenedorInformacion.gd
class_name ContenedorInformacion
extends NinePatchRect

##Atributos export
export var autoOcultar:bool = false

##Atributos onready
onready var animacion:AnimationPlayer = $AnimationPlayer
onready var textoContenedor:Label = $Label
onready var autoOcultarTimer:Timer = $AutoOcultarTimer

##Atributos
var estaActivado:bool = true setget setEstaActivo

##Setters y Getters
func setEstaActivo(valor: bool) -> void:
	estaActivado = valor

##Metodos Custom
func modificarTexto(text: String) -> void:
	textoContenedor.text = text

func mostrar() -> void:
	if estaActivado:
		animacion.play("mostrar")

func ocultar() -> void:
	if not estaActivado:
		animacion.stop()
	animacion.play("ocultar")

func mostrarSuavizado() -> void:
	if not estaActivado:
		return
	animacion.play("mostrarSuavizado")
	if autoOcultar:
		autoOcultarTimer.start()

func ocultarSuavizado() -> void:
	if estaActivado:
		animacion.play("ocultarSuavizado")
	animacion.play("ocultarSuavizado")

##Conexion Seniales Internas
func _on_AutoOcultarTimer_timeout() -> void:
	ocultarSuavizado()
