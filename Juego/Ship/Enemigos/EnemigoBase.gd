#EnemigoBase.gd
class_name EnemigoBase
extends NaveBase

##Atributos
var playerObjetivo:Player = null

##Metodos
func _ready() -> void:
	playerObjetivo = DatosJuego.getPlayerActual()
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")

func _physics_process(delta: float) -> void:
	rotarHaciaPlayer()

##Metodos Custom
func _on_nave_destruida(nave: NaveBase, _posicion, _num_explosiones) -> void:
	if nave is Player:
		playerObjetivo = null

func rotarHaciaPlayer() -> void:
	if playerObjetivo:
		var dirPlayer:Vector2 = playerObjetivo.global_position - global_position
		rotation = dirPlayer.angle()

##Señales Internas
func _on_body_entered(body: Node) -> void:
	._on_body_entered(body)
	if body is Player:
		body.destruir()
		destruir() 
