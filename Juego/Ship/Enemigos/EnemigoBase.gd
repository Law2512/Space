#EnemigoBase.gd
class_name EnemigoBase
extends NaveBase

##Atributos
var playerObjetivo:Player = null
var dirPlayer:Vector2
var frameActual:int = 0

##Metodos
func _ready() -> void:
	playerObjetivo = DatosJuego.getPlayerActual()
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")

func _physics_process(_delta: float) -> void:
	frameActual += 1
	if frameActual % 3 == 0:
		rotarHaciaPlayer()

##Metodos Custom
func _on_nave_destruida(nave: NaveBase, _posicion, _num_explosiones) -> void:
	if nave is Player:
		playerObjetivo = null
	
	if nave.is_in_group("minimapa"):
		Eventos.emit_signal("minimapaObjetoDestruido", nave)

func rotarHaciaPlayer() -> void:
	if playerObjetivo:
		dirPlayer = playerObjetivo.global_position - global_position
		rotation = dirPlayer.angle()

##Señales Internas
func _on_body_entered(body: Node) -> void:
	._on_body_entered(body)
	if body is Player:
		body.destruir()
		destruir() 
